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
- `settings.json` — User-scope settings (permissions, model, hooks, etc.)
- `agents/` — Subagent definitions
- `skills/` — Skill definitions (modular, each skill is a directory)
- `commands/` — Custom slash-command definitions
- `plans/` — Persistent plans

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

## Install This Config

The contents of this repository should be placed in your `$HOME`.

```bash
git clone https://github.com/dotbrains/claude.git $HOME/.claude
```

If using submodules:

```bash
git clone --recursive https://github.com/dotbrains/claude.git $HOME/.claude
```

## Extending with Submodules

You can pull in shared agents, skills, or commands from external repositories:

```bash
# Add a shared agent library
git submodule add https://github.com/example/claude-agents.git agents/shared

# Add shared skills
git submodule add https://github.com/example/claude-skills.git skills/shared

# Add community commands
git submodule add https://github.com/example/claude-commands.git commands/shared
```

## License

This project is licensed under the [PolyForm Shield License 1.0.0](https://polyformproject.org/licenses/shield/1.0.0/) -- see [LICENSE](LICENSE) for details.
