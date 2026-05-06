#!/usr/bin/env bash

# Claude Code status line — mirrors Starship/Gruvbox Dark prompt style
# Receives JSON on stdin from Claude Code

input=$(cat)

# --- Data extraction ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
git_branch=""
git_status=""
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# Shorten path: replace $HOME with ~, truncate to last 3 components
home="$HOME"
short_path="${cwd/#$home/\~}"
# Truncate to last 3 path segments
short_path=$(echo "$short_path" | awk -F'/' '{
    n = split($0, a, "/");
    if (n > 3) {
        print "…/" a[n-2] "/" a[n-1] "/" a[n]
    } else {
        print $0
    }
}')

# --- Git info (skip optional locks) ---
if [ -n "$cwd" ] && git -C "$cwd" rev-parse --git-dir --no-optional-locks >/dev/null 2>&1; then
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
    [ -n "$flags" ] && git_status=" [$flags]"
fi

# --- Gruvbox Dark ANSI colors ---
YELLOW='\033[38;2;250;189;47m'      # #fabd2f  bright yellow  — directory
GREEN='\033[38;2;142;192;124m'      # #8ec07c  bright aqua    — branch + icon
RED='\033[38;2;251;73;52m'          # #fb4934  bright red     — git status flags
FG1='\033[38;2;235;219;178m'        # #ebdbb2  fg1            — "on" connector, model name
FG2='\033[38;2;213;196;161m'        # #d5c4a1  fg2            — "on" connector
GRAY='\033[38;2;146;131;116m'       # #928374  gray           — separator, ctx%
ORANGE='\033[38;2;254;128;25m'      # #fe8019  bright orange  — ctx% emphasis
BOLD='\033[1m'
RESET='\033[0m'

# --- Assemble line ---
# Format: <dir>  on  <branch> [status]  |  <model>  ctx:<used>%
parts=""

# Directory
parts="${parts}${BOLD}${YELLOW}${short_path}${RESET}"

# Git
if [ -n "$git_branch" ]; then
    parts="${parts} ${FG2}on${RESET} ${GREEN} ${git_branch}${RESET}"
    if [ -n "$git_status" ]; then
        parts="${parts}${RED}${git_status}${RESET}"
    fi
fi

# Model
if [ -n "$model" ]; then
    parts="${parts} ${GRAY}|${RESET} ${FG1}${model}${RESET}"
fi

# Context usage
if [ -n "$used_pct" ]; then
    used_int=$(printf '%.0f' "$used_pct")
    parts="${parts} ${ORANGE}ctx:${used_int}%${RESET}"
fi

printf "%b\n" "$parts"
