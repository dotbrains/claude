# Plugins

This document lists the external MCP servers and plugins used by this Claude Code configuration.

## claude-hud

**Type:** Claude Code Plugin (Marketplace)

A statusline plugin that shows what's happening — context usage, active tools, running agents, and todo progress. Always visible below your input.

- **Features:** Context bar, tool activity, agent tracking, todo progress, git status, session cost/duration
- **Requirements:** Claude Code v1.0.80+, Node.js 18+ or Bun

### Install

```bash
/plugin marketplace add jarrodwatts/claude-hud
/plugin install claude-hud
/reload-plugins
```

### Setup

```bash
/claude-hud:setup
```

Follow the guided flow to choose a preset (Full/Essential/Minimal) and customize your display.

### Configure

```bash
/claude-hud:configure
```

### Requirements

- Claude Code v1.0.80+
- Node.js 18+ or Bun

## Linear

**Type:** Remote MCP (OAuth)

Linear's official MCP server for issue tracking, project management, and team workflows.

- **URL:** `https://mcp.linear.app/mcp`
- **Auth:** Run `/mcp` in Claude Code and complete the browser-based OAuth flow for Linear

### Verify

```bash
claude mcp list
```

### Fallback: linear-cli (when MCP auth is blocked)

If your workspace blocks Linear MCP authentication or installation, you can still use Linear in Claude Code through local slash commands powered by `@dotbrains/linear-cli`.

#### 1) Install linear-cli

```bash
npm config set @dotbrains:registry https://npm.pkg.github.com
npm config set //npm.pkg.github.com/:_authToken $(gh auth token)
npm install -g @dotbrains/linear-cli
```

#### 2) Configure credentials

```bash
linear init
```

This creates `~/.config/linear/config.json` with your Linear API key.

#### 3) Use the fallback slash commands

Two commands are included in `commands/`:

- `/linear-search <term>` - runs `linear search "<term>"`
- `/linear-issue <id-or-identifier>` - runs `linear issue "<id-or-identifier>"`

Example:

```text
/linear-search auth bug
/linear-issue ENG-123
```

## Notion

**Type:** Remote MCP (OAuth)

Notion's official hosted MCP server for reading and writing workspace content.

- **URL:** `https://mcp.notion.com/mcp`
- **Auth:** Run `/mcp` in Claude Code and complete the browser-based OAuth flow for Notion

### Verify

```bash
claude mcp list
```

### Fallback: notion-cli (when MCP auth is blocked)

If your workspace blocks Notion MCP installation (for example, approved-connections restrictions), you can still use Notion in Claude Code through local slash commands powered by `@dotbrains/notion-cli`.

#### 1) Install notion-cli

```bash
npm config set @dotbrains:registry https://npm.pkg.github.com
npm config set //npm.pkg.github.com/:_authToken $(gh auth token)
npm install -g @dotbrains/notion-cli
```

#### 2) Configure credentials

```bash
notion init
```

This creates `~/.config/notion/config.json` with your Notion credentials.

#### 3) Use the fallback slash commands

Two commands are included in `commands/`:

- `/notion-search <query>` - runs `notion search "<query>" --json --limit 20`
- `/notion-page <page-id>` - runs `notion page "<page-id>" --json`

Example:

```text
/notion-search onboarding checklist
/notion-page 01234567-89ab-cdef-0123-456789abcdef
```

## context-mode

**Repository:** [mksglu/context-mode](https://github.com/mksglu/context-mode)

Context Mode is an MCP server that keeps raw tool output out of your context window and tracks session state in SQLite for continuity across compactions.

- **MCP tools:** `ctx_batch_execute`, `ctx_execute`, `ctx_execute_file`, `ctx_index`, `ctx_search`, `ctx_fetch_and_index`
- **Slash commands:** `/context-mode:ctx-stats`, `/context-mode:ctx-doctor`, `/context-mode:ctx-upgrade`

### Prerequisites

- Node.js 18+
- Claude Code v1.0.33+ (`claude --version`)

### Install

The `settings.json` in this repo already registers context-mode as an MCP server (via `npx`), so the tools are available out of the box.

For full integration — hooks (`PreToolUse`, `PostToolUse`, `PreCompact`, `SessionStart`), slash commands, and automatic routing — also install the plugin from the marketplace:

```bash
/plugin marketplace add mksglu/context-mode
/plugin install context-mode@context-mode
```

Restart Claude Code (or run `/reload-plugins`).

### Verify

```
/context-mode:ctx-doctor
```

All checks should show `[x]`. Without the marketplace plugin, you can still verify with:

```
ctx doctor
```

### Upgrade

From within Claude Code:

```
/context-mode:ctx-upgrade
```

Or manually:

```bash
npm update -g context-mode
```

## Superpowers

**Repository:** [obra/superpowers](https://github.com/obra/superpowers)

Superpowers is a complete software development workflow for AI coding agents. It provides a composable set of "skills" that trigger automatically based on context.

### Core Workflow

1. **brainstorming** - Activates before writing code. Refines ideas through questions, presents design in chunks.
2. **writing-plans** - Breaks work into bite-sized tasks with exact file paths and verification steps.
3. **subagent-driven-development** - Dispatches subagents per task with two-stage review.
4. **test-driven-development** - Enforces RED-GREEN-REFACTOR cycle.
5. **requesting-code-review** - Reviews against plan, reports issues by severity.

### Skills Library

- `brainstorming` - Socratic design refinement
- `writing-plans` - Detailed implementation plans
- `subagent-driven-development` - Fast iteration with review
- `test-driven-development` - RED-GREEN-REFACTOR cycle
- `systematic-debugging` - 4-phase root cause process
- And more...

### Installation

Install from the official marketplace:

```bash
/plugin install superpowers@claude-plugins-official
```

Or search for "superpowers" in the plugin marketplace.

### Usage

```
/brainstorming
```

Verify by asking: "Tell me about your superpowers"

## Get Shit Done (GSD)

**Repository:** [gsd-build/get-shit-done](https://github.com/gsd-build/get-shit-done)

A meta-prompting, context engineering, and spec-driven development system that solves context rot — the quality degradation that happens as AI fills its context window.

### Core Workflow

1. **`/gsd:new-project`** - Full initialization: questions → research → requirements → roadmap
2. **`/gsd:discuss-phase [N]`** - Capture implementation decisions before planning
3. **`/gsd:plan-phase [N]`** - Research + plan + verify for a phase
4. **`/gsd:execute-phase [N]`** - Execute all plans in parallel waves
5. **`/gsd:verify-work [N]`** - Manual user acceptance testing
6. **`/gsd:ship [N]`** - Create PR from verified phase work

### Key Commands

| Command | Description |
|---------|-------------|
| `/gsd:new-project` | Initialize new project with full workflow |
| `/gsd:quick` | Fast ad-hoc task execution |
| `/gsd:map-codebase` | Analyze existing codebase |
| `/gsd:discuss-phase` | Capture implementation decisions |
| `/gsd:plan-phase` | Research and plan phase |
| `/gsd:execute-phase` | Execute plans in waves |
| `/gsd:verify-work` | User acceptance testing |
| `/gsd:ship` | Create PR from verified work |
| `/gsd:progress` | Where am I? What's next? |
| `/gsd:help` | Show all commands |

### Installation

GSD commands are included in this repository under `commands/`. They were installed via:

```bash
npx get-shit-done-cc@latest --claude --global
```

### Usage

```
/gsd:help
```

### Quick Mode

For ad-hoc tasks that don't need full planning:

```
/gsd:quick
> What do you want to do? "Add dark mode toggle to settings"
```

### Configuration

Project settings stored in `.planning/config.json`. Configure via `/gsd:settings`.

### Model Profiles

Control which Claude model each agent uses:

- `quality` - Opus for planning/execution, Sonnet for verification
- `balanced` - Opus / Sonnet / Sonnet (default)
- `budget` - Sonnet / Sonnet / Haiku

Restart Claude Code (or run `/reload-plugins`).

### Verify

```bash
/context-mode:ctx-doctor
```

All checks should show `[x]`. Without the marketplace plugin, you can still verify with:

```
ctx doctor
```

### Upgrade

From within Claude Code:

```bash
/context-mode:ctx-upgrade
```

Or manually:

```bash
npm update -g context-mode
```
