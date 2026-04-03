# claude

[![License: PolyForm Shield 1.0.0](https://img.shields.io/badge/License-PolyForm%20Shield%201.0.0-blue.svg)](https://polyformproject.org/licenses/shield/1.0.0/)

This repository contains my sensible defaults for [Claude Code](https://docs.anthropic.com/en/docs/claude-code).

## Upstream Project

- https://github.com/anthropics/claude-code

## Install Claude Code

```bash
npm install -g @anthropic-ai/claude-code
```

## Contents

- `CLAUDE.md` — User-scope memory and instructions (read every session)
- `settings.json` — User-scope settings (permissions, MCP servers, hooks, etc.)
- `agents/` — Subagent definitions (assembled from shared + frontmatter)
- `skills/` — Skill definitions (modular, each skill is a directory)
- `commands/` — Custom slash-command definitions
- `plans/` — Persistent plans
- `shared/` — Shared AI config submodule ([dotbrains/shared-ai-config](https://github.com/dotbrains/shared-ai-config))
- `frontmatter/` — Claude Code-specific YAML frontmatter for agents and skills
- `PLUGINS.md` — External MCP servers and plugins ([details](PLUGINS.md))
- `RULES.md` — Rule definitions and usage ([details](RULES.md))

### Agents

| Agent | Purpose |
|---|---|
| `tech-lead` | Orchestrates complex workflows across specialist agents |
| `architect-designer` | High-level design, pattern selection, structural planning |
| `implementation-specialist` | Precise, scoped coding tasks with zero architectural drift |
| `requirements-clarifier` | Transforms vague requirements into actionable specifications |
| `test-automation-engineer` | Comprehensive test coverage, execution, and failure diagnosis |
| `task-decomposer` | Breaks overwhelming complexity into sequential action items |

### Skills

| Skill | Purpose | Invocation |
|---|---|---|
| `ship` | Commit, push, and open a PR | `/ship` |
| `explain-code` | Explain code with diagrams and analogies | `/explain-code` or automatic |
| `pr-review` | Review a pull request thoroughly | `/pr-review <PR number>` |

### Commands

| Command | Purpose |
|---|---|
| `linear-issue` | Fetch a Linear issue by ID or identifier |
| `linear-search` | Search Linear for issues, projects, or documents |
| `notion-page` | Fetch a Notion page by ID |
| `notion-search` | Search Notion for pages |

## Install This Config

The contents of this repository should be placed in your `$HOME`.

```bash
git clone --recursive https://github.com/dotbrains/claude.git $HOME/.claude
```

### Install Plugins

After cloning, run the plugin installation script:

```bash
./install-plugins.sh
```

This installs:
- `@dotbrains/linear-cli` - Fallback CLI for Linear
- `@dotbrains/notion-cli` - Fallback CLI for Notion

## Shared Agent Definitions

Agent and skill body content is shared with [OpenCode](https://github.com/dotbrains/opencode) via the [shared-ai-config](https://github.com/dotbrains/shared-ai-config) submodule. To update after shared content changes:

```bash
git submodule update --remote shared
./shared/assemble.sh claude
```

## Extending with Submodules

You can pull in shared agents, skills, or commands from external repositories:

```bash
# Add shared skills
git submodule add https://github.com/example/claude-skills.git skills/shared

# Add community commands
git submodule add https://github.com/example/claude-commands.git commands/shared
```

## Fallback Commands (Notion + Linear)

If your workspace blocks MCP OAuth flows, this config includes local fallback slash commands:

- Notion: `commands/notion-search.md`, `commands/notion-page.md` (powered by `@dotbrains/notion-cli`)
- Linear: `commands/linear-search.md`, `commands/linear-issue.md` (powered by `@dotbrains/linear-cli`)

Setup and usage instructions are documented in `PLUGINS.md` under:

- **Linear - Fallback: linear-cli (when MCP auth is blocked)**
- **Notion - Fallback: notion-cli (when MCP auth is blocked)**

## License

This project is licensed under the [PolyForm Shield License 1.0.0](https://polyformproject.org/licenses/shield/1.0.0/) -- see [LICENSE](LICENSE) for details.
