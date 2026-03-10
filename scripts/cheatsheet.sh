#!/bin/bash
DOCS="$HOME/dotfiles/docs"

if [ -n "$1" ]; then
  file="$DOCS/$1-cheatsheet.md"
  if [ -f "$file" ]; then
    glow -p "$file"
  else
    echo "Not found: $1-cheatsheet.md"
    echo "Available:"
    ls "$DOCS"/*-cheatsheet.md 2>/dev/null | xargs -I{} basename {} -cheatsheet.md
  fi
else
  echo "Choose a cheatsheet:"
  files=$(ls "$DOCS"/*-cheatsheet.md 2>/dev/null)
  i=1
  for f in $files; do
    name=$(basename "$f" -cheatsheet.md)
    echo "  $i) $name"
    names[i]=$name
    ((i++))
  done
  echo ""
  read -p "> " choice
  if [[ "$choice" =~ ^[0-9]+$ ]] && [ -n "${names[$choice]}" ]; then
    glow -p "$DOCS/${names[$choice]}-cheatsheet.md"
  else
    glow -p "$DOCS/$choice-cheatsheet.md" 2>/dev/null || echo "Not found"
  fi
fi
