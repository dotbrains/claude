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

# superpowers - Complete software development workflow
# Installed via Claude Code marketplace plugin
echo "Installing superpowers (via marketplace plugin)..."
echo "Run: /plugin install superpowers@claude-plugins-official"
echo "Or search for 'superpowers' in the plugin marketplace"

# get-shit-done - GSD workflow system
echo "Installing get-shit-done..."
npx get-shit-done-cc@latest --claude --global

echo ""
echo "Done! Restart Claude Code to load the plugins."
echo ""
echo "Verify with:"
echo "  claude mcp list"
