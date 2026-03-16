#!/bin/bash
set -euo pipefail

TEMPLATES="$HOME/dotfiles/ai/templates"

if [ -z "${1:-}" ]; then
  echo "Usage: ai-init <project-path>"
  exit 1
fi

PROJECT_PATH="${1:-.}"
PROJECT_NAME=$(basename "$(realpath "$PROJECT_PATH")")

echo "Initializing AI context for: $PROJECT_NAME"

# Create .ai directory
mkdir -p "$PROJECT_PATH/.ai"
cp "$TEMPLATES/STATUS.md" "$PROJECT_PATH/.ai/STATUS.md"
cp "$TEMPLATES/DECISIONS.md" "$PROJECT_PATH/.ai/DECISIONS.md"
cp "$TEMPLATES/GLOSSARY.md" "$PROJECT_PATH/.ai/GLOSSARY.md"

# Create AGENTS.md from template
sed "s/\[PROJECT_NAME\]/$PROJECT_NAME/" "$TEMPLATES/AGENTS.md" > "$PROJECT_PATH/AGENTS.md"

# Symlinks for cross-tool compatibility
cd "$PROJECT_PATH"
ln -sf AGENTS.md CLAUDE.md
ln -sf AGENTS.md GEMINI.md

# Aider project config — auto-read AGENTS.md
cat > .aider.conf.yml << 'EOF'
read: AGENTS.md
EOF

echo "Created:"
echo "  AGENTS.md          — Project instructions (edit this)"
echo "  CLAUDE.md          — Symlink → AGENTS.md"
echo "  GEMINI.md          — Symlink → AGENTS.md"
echo "  .aider.conf.yml    — Aider config (reads AGENTS.md)"
echo "  .ai/STATUS.md      — Session handoff status"
echo "  .ai/DECISIONS.md   — Architecture decisions"
echo "  .ai/GLOSSARY.md    — Domain terms"
echo ""
echo "Next: Edit AGENTS.md with your project details"
