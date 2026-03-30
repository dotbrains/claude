# Plugins

This document lists the external MCP servers and plugins used by this Claude Code configuration.

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
