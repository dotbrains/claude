# Rules

This document lists the persistent instructions loaded by Claude Code on every session.

## How It Works

Claude Code reads `~/.claude/CLAUDE.md` at session start. This file serves as global instructions and preferences. Per-project rules go in `CLAUDE.md` or `.claude/CLAUDE.md` within the repository.

Settings-based rules (like attribution) are configured in `settings.json`.

## Active Rules

### Commit Attribution

Configured via `settings.json`:

```json
{
  "attribution": {
    "commit": "",
    "pr": ""
  }
}
```

Setting both fields to empty strings disables all AI attribution in commits and PRs. The `CLAUDE.md` file also includes an explicit rule as a belt-and-suspenders measure.

**Why:** Claude Code appends `Co-Authored-By: claude` and "Generated with Claude Code" by default. This disables both. See [attribution settings](https://code.claude.com/docs/en/settings) for details.

### Git Conventions

Enforced in `CLAUDE.md`:
- Conventional commits (`feat:`, `fix:`, `docs:`, etc.)
- First line ≤ 72 characters, imperative mood
- Never force-push to `main`/`master`
- Never commit secrets or `.env` files

## Adding New Rules

1. For behavior rules, add them to `CLAUDE.md` under a descriptive heading
2. For settings-based rules, add them to `settings.json`

Rules in `CLAUDE.md` are loaded every session and take effect immediately. Changes to `settings.json` apply on the next session start.
