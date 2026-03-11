#!/usr/bin/env bash

# Tmux sessionizer - tạo/switch session theo project folder
# Usage: sessionizer.sh [optional search term]

SEARCH_DIRS="$HOME/projects $HOME/work $HOME/dotfiles"

# Tìm tất cả subfolder (depth 1) + các thư mục gốc
selected=$(find $SEARCH_DIRS -mindepth 0 -maxdepth 1 -type d 2>/dev/null | \
  fzf --reverse --query="$1" --select-1)

[ -z "$selected" ] && exit 0

# Tên session = tên folder, thay dấu . thành _
session_name=$(basename "$selected" | tr '.' '_')

# Nếu chưa có tmux, tạo session mới
if ! tmux has-session -t "$session_name" 2>/dev/null; then
  tmux new-session -ds "$session_name" -c "$selected"
fi

# Switch vào session
if [ -n "$TMUX" ]; then
  tmux switch-client -t "$session_name"
else
  tmux attach-session -t "$session_name"
fi
