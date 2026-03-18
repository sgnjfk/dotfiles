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

safe_copy() {
  if [ -f "$2" ]; then
    echo "  SKIP $2 (already exists)"
  else
    cp "$1" "$2"
    echo "  CREATE $2"
  fi
}

mkdir -p "$PROJECT_PATH/.ai"
safe_copy "$TEMPLATES/STATUS.md" "$PROJECT_PATH/.ai/STATUS.md"
safe_copy "$TEMPLATES/DECISIONS.md" "$PROJECT_PATH/.ai/DECISIONS.md"
safe_copy "$TEMPLATES/GLOSSARY.md" "$PROJECT_PATH/.ai/GLOSSARY.md"

if [ -f "$PROJECT_PATH/AGENTS.md" ]; then
  echo "  SKIP AGENTS.md (already exists)"
else
  sed "s/\[PROJECT_NAME\]/$PROJECT_NAME/" "$TEMPLATES/AGENTS.md" > "$PROJECT_PATH/AGENTS.md"
  echo "  CREATE AGENTS.md"
fi

# Symlinks — always safe to recreate
cd "$PROJECT_PATH"
ln -sf AGENTS.md CLAUDE.md
ln -sf AGENTS.md GEMINI.md
echo "  LINK CLAUDE.md → AGENTS.md"
echo "  LINK GEMINI.md → AGENTS.md"

if [ -f .aider.conf.yml ]; then
  echo "  SKIP .aider.conf.yml (already exists)"
else
  cat > .aider.conf.yml << 'EOF'
read: AGENTS.md
EOF
  echo "  CREATE .aider.conf.yml"
fi

echo ""
echo "Done. Edit AGENTS.md with your project details."
