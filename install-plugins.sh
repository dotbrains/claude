#!/bin/bash
set -e

# Install plugins for Claude Code configuration

echo "Installing Claude Code plugins..."

# Check for npm
if ! command -v npm &> /dev/null; then
    echo "Error: npm is not installed"
    exit 1
fi

# context-mode - MCP server (via npx, no install needed)
echo "context-mode is configured via npx in settings.json (no install needed)"

# linear-cli - fallback for Linear
echo "Installing linear-cli..."
npm config set @dotbrains:registry https://npm.pkg.github.com
npm config set //npm.pkg.github.com/:_authToken "$(gh auth token)" 2>/dev/null || true
npm install -g @dotbrains/linear-cli

# notion-cli - fallback for Notion
echo "Installing notion-cli..."
npm install -g @dotbrains/notion-cli

echo ""
echo "Done! Restart Claude Code to load the plugins."
echo ""
echo "Verify with:"
echo "  claude mcp list"
