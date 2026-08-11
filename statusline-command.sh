#!/usr/bin/env bash

# Claude Code status line — mirrors Starship/Gruvbox Dark prompt style
# Receives JSON on stdin from Claude Code

input=$(cat)

# --- Data extraction ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // empty')
cost_usd=$(echo "$input" | jq -r '.cost.total_cost_usd // empty')
git_branch=""
git_status=""
repo_name=""

# --- Repo name + git info (skip optional locks) ---
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir --no-optional-locks >/dev/null 2>&1; then
    toplevel=$(git -C "$cwd" --no-optional-locks rev-parse --show-toplevel 2>/dev/null)
    repo_name=$(basename "${toplevel:-$cwd}")
    git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
        || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
    # Status flags (mirrors Starship git_status: !, +, ?, ↑)
    flags=""
    git_st=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)
    echo "$git_st" | grep -qE '^( M|M |MM|AM)' && flags="${flags}!"
    echo "$git_st" | grep -qE '^(A |MA)' && flags="${flags}+"
    echo "$git_st" | grep -q '^\?\?' && flags="${flags}?"
    ahead=$(git -C "$cwd" --no-optional-locks rev-list --count "@{u}..HEAD" 2>/dev/null)
    [ -n "$ahead" ] && [ "$ahead" -gt 0 ] && flags="${flags}↑${ahead}"
    [ -n "$flags" ] && git_status="${flags}"
elif [ -n "$cwd" ]; then
    repo_name=$(basename "$cwd")
fi

# --- Formatting helpers ---
format_duration() {
    local total_s=$(( $1 / 1000 ))
    local h=$(( total_s / 3600 ))
    local m=$(( (total_s % 3600) / 60 ))
    local s=$(( total_s % 60 ))
    if [ "$h" -gt 0 ]; then
        printf '%dh%02dm' "$h" "$m"
    elif [ "$m" -gt 0 ]; then
        printf '%dm%02ds' "$m" "$s"
    else
        printf '%ds' "$s"
    fi
}

# --- Gruvbox Dark ANSI colors ---
YELLOW='\033[38;2;250;189;47m'      # #fabd2f  bright yellow  — repo name
GREEN='\033[38;2;142;192;124m'      # #8ec07c  bright aqua    — branch
RED='\033[38;2;251;73;52m'          # #fb4934  bright red     — git status flags
FG1='\033[38;2;235;219;178m'        # #ebdbb2  fg1            — model name
FG2='\033[38;2;213;196;161m'        # #d5c4a1  fg2            — session duration
BLUE='\033[38;2;131;165;152m'       # #83a598  bright blue    — session cost
GRAY='\033[38;2;146;131;116m'       # #928374  gray           — separators
ORANGE='\033[38;2;254;128;25m'      # #fe8019  bright orange  — ctx% emphasis
BOLD='\033[1m'
RESET='\033[0m'

# --- Assemble line ---
# Format: <repo> (<branch>[status])  [<model>]  ctx:<used>%  <duration>  <cost>
parts=""

# Repo + branch
if [ -n "$repo_name" ]; then
    parts="${parts}${BOLD}${YELLOW}${repo_name}${RESET}"
fi
if [ -n "$git_branch" ]; then
    parts="${parts} ${GRAY}(${GREEN}${git_branch}${RESET}"
    if [ -n "$git_status" ]; then
        parts="${parts} ${RED}${git_status}${RESET}"
    fi
    parts="${parts}${GRAY})${RESET}"
fi

# Model
if [ -n "$model" ]; then
    parts="${parts} ${GRAY}[${RESET}${FG1}${model}${RESET}${GRAY}]${RESET}"
fi

# Context usage
if [ -n "$used_pct" ]; then
    used_int=$(printf '%.0f' "$used_pct")
    parts="${parts} ${ORANGE}ctx:${used_int}%${RESET}"
fi

# Session duration
if [ -n "$duration_ms" ]; then
    parts="${parts} ${FG2}$(format_duration "$duration_ms")${RESET}"
fi

# Session cost
if [ -n "$cost_usd" ]; then
    parts="${parts} ${BLUE}\$$(printf '%.2f' "$cost_usd")${RESET}"
fi

printf "%b\n" "$parts"
