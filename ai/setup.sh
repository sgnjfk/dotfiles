#!/bin/bash
set -euo pipefail

DOTFILES="$HOME/dotfiles"
AI_DIR="$DOTFILES/ai"

echo "=== AI Development System Setup ==="

# Claude Code
echo "[1/3] Setting up Claude Code..."
mkdir -p "$HOME/.claude"
ln -sf "$DOTFILES/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
ln -sf "$DOTFILES/claude/settings.json" "$HOME/.claude/settings.json"
echo "  ✓ Claude Code configured"

# Codex CLI
echo "[2/3] Setting up Codex CLI..."
mkdir -p "$HOME/.codex"
ln -sf "$AI_DIR/codex-agents.md" "$HOME/.codex/AGENTS.md"
echo "  ✓ Codex CLI configured"

# Gemini CLI
echo "[3/3] Setting up Gemini CLI..."
mkdir -p "$HOME/.gemini"
ln -sf "$AI_DIR/gemini-instructions.md" "$HOME/.gemini/GEMINI.md"
echo "  ✓ Gemini CLI configured"

echo ""
echo "=== Setup Complete ==="
echo ""
echo "To init a new project with AI context:"
echo "  ai-init <project-path>"
