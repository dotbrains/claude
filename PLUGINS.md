# Plugins

This document lists the external MCP servers and plugins used by this Claude Code configuration.

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
