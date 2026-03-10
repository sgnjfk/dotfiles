#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"

echo "=== Dotfiles Install ==="

# Neovim
echo "[nvim] Linking config..."
mkdir -p ~/.config
rm -rf ~/.config/nvim
ln -sf "$DOTFILES/nvim" ~/.config/nvim
echo "[nvim] Done"

# Tmux
echo "[tmux] Linking config..."
ln -sf "$DOTFILES/tmux/tmux.conf" ~/.tmux.conf
echo "[tmux] Done"

# Zsh
if [ -f "$DOTFILES/zsh/.zshrc" ]; then
  echo "[zsh] Linking config..."
  ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
  echo "[zsh] Done"
fi

echo ""
echo "=== All done! ==="
echo "Restart tmux: tmux source ~/.tmux.conf"
echo "Restart nvim: just open nvim"
