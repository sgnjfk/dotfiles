#!/usr/bin/env bash

set -euo pipefail

pane_id="${1:-${TMUX_PANE:-}}"
provider="${2:-auto}"
buffer_name="${3:-}"
context_mode="${4:-basic}"
view_only="${5:-run}"

if [ "$view_only" = "view" ]; then
  exec "$HOME/dotfiles/scripts/tmux-btw-view.sh" "$pane_id"
fi

[ -z "$pane_id" ] && {
  echo "tmux-btw: missing pane id" >&2
  exit 1
}

current_cmd="$(tmux display-message -p -t "$pane_id" '#{pane_current_command}')"
current_path="$(tmux display-message -p -t "$pane_id" '#{pane_current_path}')"

if [ "$provider" = "auto" ]; then
  case "$current_cmd" in
    gemini) provider="gemini" ;;
    codex) provider="codex" ;;
    *)
      if command -v codex >/dev/null 2>&1; then
        provider="codex"
      else
        provider="gemini"
      fi
      ;;
  esac
fi

question=""
if [ -n "$buffer_name" ]; then
  question="$(tmux show-buffer -b "$buffer_name" 2>/dev/null || true)"
  tmux delete-buffer -b "$buffer_name" >/dev/null 2>&1 || true
fi

if [ -z "$question" ]; then
  clear
  printf 'Side chat provider: %s\n' "$provider"
  printf 'Source pane command: %s\n' "$current_cmd"
  printf 'Working directory: %s\n\n' "$current_path"
  printf 'BTW> '
  IFS= read -r question
fi

[ -z "$question" ] && exit 0

parsed="$(python3 -c "
import json, shlex, sys

text = sys.argv[1]
tokens = shlex.split(text)
context_lines = 160
context_mode = sys.argv[2]
no_context = False
question_tokens = []

i = 0
while i < len(tokens):
    tok = tokens[i]
    if tok in ('-c', '--context-lines'):
        if i + 1 >= len(tokens):
            raise SystemExit(1)
        context_lines = int(tokens[i + 1])
        i += 2
    elif tok in ('-r', '--rich'):
        context_mode = 'rich'
        i += 1
    elif tok in ('-b', '--basic'):
        context_mode = 'basic'
        i += 1
    elif tok in ('-n', '--no-context'):
        no_context = True
        i += 1
    else:
        question_tokens = tokens[i:]
        break

if context_lines < 20:
    context_lines = 20
if context_lines > 2000:
    context_lines = 2000

question = ' '.join(question_tokens).strip()
if not question:
    raise SystemExit(1)

print(json.dumps({
    'context_lines': context_lines,
    'context_mode': context_mode,
    'no_context': no_context,
    'question': question,
}))
" "$question" "$context_mode" 2>/dev/null)" || {
  printf '%s\n' "Invalid BTW options." >&2
  printf '%s\n' "Usage: [-n|--no-context] [-c 250] [-r|--rich] <question>" >&2
  exit 1
}

context_lines="$(printf '%s' "$parsed" | python3 -c 'import json,sys; print(json.load(sys.stdin)["context_lines"])')"
context_mode="$(printf '%s' "$parsed" | python3 -c 'import json,sys; print(json.load(sys.stdin)["context_mode"])')"
no_context="$(printf '%s' "$parsed" | python3 -c 'import json,sys; print("true" if json.load(sys.stdin)["no_context"] else "false")')"
question="$(printf '%s' "$parsed" | python3 -c 'import json,sys; print(json.load(sys.stdin)["question"])')"
context=""
[ "$no_context" != "true" ] && context="$(tmux capture-pane -p -J -t "$pane_id" -S "-$context_lines")"

prompt_file="$(mktemp)"
extra_context_file="$(mktemp)"
trap 'rm -f "$prompt_file" "$extra_context_file"' EXIT

git_root=""
if git -C "$current_path" rev-parse --show-toplevel >/dev/null 2>&1; then
  git_root="$(git -C "$current_path" rev-parse --show-toplevel)"
fi

if [ "$no_context" = "true" ]; then
  printf '%s\n' "No additional pane/workspace context attached." > "$extra_context_file"
else
  {
    printf 'Pane command: %s\n' "$current_cmd"
    printf 'Working directory: %s\n' "$current_path"
    if [ -n "$git_root" ]; then
      printf 'Git root: %s\n\n' "$git_root"
      printf 'Git status:\n'
      git -C "$current_path" status --short --branch 2>/dev/null || true
      if [ "$context_mode" = "rich" ]; then
        printf '\nTracked/untracked files (first 120):\n'
        git -C "$current_path" ls-files -co --exclude-standard 2>/dev/null | head -n 120 || true
        printf '\nRecent commits:\n'
        git -C "$current_path" log --oneline -n 8 2>/dev/null || true
      fi
    elif [ "$context_mode" = "rich" ]; then
      printf '\nDirectory listing (first 120):\n'
      find "$current_path" -maxdepth 2 -mindepth 1 2>/dev/null | sed "s|^$current_path/||" | sort | head -n 120 || true
    fi
  } > "$extra_context_file"
fi

cat > "$prompt_file" <<EOF
You are answering a temporary one-shot side question opened from an existing terminal AI session.

Rules:
- Treat this as a side question, not the main task.
- Use the captured terminal transcript and workspace summary only as background context.
- Answer directly and briefly unless the user asks for depth.
- Do not continue the main task or make edits unless explicitly asked here.
- If the transcript is insufficient, say so plainly.
- Do not assume the pane must be running Codex or Gemini; the user may have opened this from a normal shell.

Workspace summary:
\`\`\`text
$(cat "$extra_context_file")
\`\`\`

Recent transcript from the main pane:
\`\`\`text
$context
\`\`\`

Side question:
$question
EOF

cd "$current_path"

output_file="$(mktemp)"
trap 'rm -f "$prompt_file" "$extra_context_file" "$output_file"' EXIT

{
  if [ "$no_context" = "true" ]; then
    printf 'BTW one-shot (%s, no-context)\n' "$provider"
  else
    printf 'BTW one-shot (%s, %s context, %s lines)\n' "$provider" "$context_mode" "$context_lines"
  fi
  printf 'Source pane command: %s\n' "$current_cmd"
  printf 'Working directory: %s\n' "$current_path"
  printf 'Question: %s\n' "$question"
  printf '%s\n\n' '────────────────────────────────────────'

  case "$provider" in
    codex)
      codex exec --skip-git-repo-check --ephemeral -s read-only -C "$current_path" "$(cat "$prompt_file")" \
        2>&1 | grep -v "^OpenAI\|^---\|^workdir\|^model\|^provider\|^approval\|^sandbox\|^reasoning\|^session\|^user\|^mcp\|^tokens" || true
      ;;
    gemini)
      gemini -p "$(cat "$prompt_file")" -o text --approval-mode plan 2>/dev/null || true
      ;;
    *)
      echo "tmux-btw: unsupported provider '$provider'" >&2
      exit 1
      ;;
  esac

  printf '\n%s\n' '────────────────────────────────────────'
  printf 'q: close  j/k or arrows: move  /: search\n'
} > "$output_file"

trap 'rm -f "$prompt_file" "$extra_context_file"' EXIT
tmux display-popup -E -w 85% -h 85% -d "$current_path" "$HOME/dotfiles/scripts/tmux-btw-view.sh '$output_file'"
