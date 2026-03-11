#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"
IS_WSL=$(grep -qi microsoft /proc/version 2>/dev/null && echo true || echo false)

echo "=== Dotfiles Install ==="
echo "[info] WSL detected: $IS_WSL"

# Backup existing configs
echo "[backup] Backing up existing configs..."
BACKUP_DIR="$HOME/dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP_DIR"
[ -f ~/.zshrc ] && cp ~/.zshrc "$BACKUP_DIR/.zshrc.bak"
[ -f ~/.tmux.conf ] && cp ~/.tmux.conf "$BACKUP_DIR/.tmux.conf.bak"
[ -f ~/.gitconfig ] && cp ~/.gitconfig "$BACKUP_DIR/.gitconfig.bak"
[ -d ~/.config/nvim ] && cp -r ~/.config/nvim "$BACKUP_DIR/nvim.bak"
[ -f ~/.ssh/config ] && cp ~/.ssh/config "$BACKUP_DIR/ssh_config.bak"
echo "[backup] Saved to $BACKUP_DIR"

# Dependencies
echo "[deps] Installing dependencies..."
sudo apt-get update -qq
sudo apt-get install -y -qq tmux git curl unzip ripgrep fd-find mosh fzf zoxide bat eza tldr duf btop neofetch thefuck jq ncdu

# WSL-only packages
if [ "$IS_WSL" = true ]; then
  sudo apt-get install -y -qq wslu
fi

# Lazygit
if ! command -v lazygit &>/dev/null; then
  echo "[deps] Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  cd /tmp && tar xzf lazygit.tar.gz lazygit && sudo install lazygit /usr/local/bin/ && rm lazygit lazygit.tar.gz
  cd -
fi

# Dust
if ! command -v dust &>/dev/null; then
  echo "[deps] Installing dust..."
  DUST_VERSION=$(curl -s https://api.github.com/repos/bootandy/dust/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
  curl -Lo /tmp/dust.deb "https://github.com/bootandy/dust/releases/latest/download/du-dust_${DUST_VERSION}-1_amd64.deb"
  sudo dpkg -i /tmp/dust.deb && rm /tmp/dust.deb
fi

# Glow (markdown renderer)
if ! command -v glow &>/dev/null; then
  echo "[deps] Installing glow..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
  sudo apt-get update -qq
  sudo apt-get install -y -qq glow
fi

# Neovim (latest)
echo "[nvim] Installing latest neovim..."
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
tar xzf nvim-linux-x86_64.tar.gz
sudo cp -rf nvim-linux-x86_64/* /usr/local/
rm -rf nvim-linux-x86_64 nvim-linux-x86_64.tar.gz
echo "[nvim] $(nvim --version | head -1)"

# win32yank (WSL clipboard only)
if [ "$IS_WSL" = true ] && ! command -v win32yank.exe &>/dev/null; then
  echo "[deps] Installing win32yank..."
  curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
  cd /tmp && unzip -o win32yank.zip win32yank.exe
  chmod +x win32yank.exe
  sudo mv win32yank.exe /usr/local/bin/
  cd -
fi

# Tmux plugins
mkdir -p ~/.config/tmux/plugins
if [ ! -d "$HOME/.config/tmux/plugins/catppuccin-tmux" ]; then
  echo "[tmux] Installing catppuccin theme..."
  git clone https://github.com/catppuccin/tmux.git ~/.config/tmux/plugins/catppuccin-tmux
fi
if [ ! -d "$HOME/.config/tmux/plugins/tmux-resurrect" ]; then
  echo "[tmux] Installing tmux-resurrect..."
  git clone https://github.com/tmux-plugins/tmux-resurrect ~/.config/tmux/plugins/tmux-resurrect
fi
if [ ! -d "$HOME/.config/tmux/plugins/tmux-continuum" ]; then
  echo "[tmux] Installing tmux-continuum..."
  git clone https://github.com/tmux-plugins/tmux-continuum ~/.config/tmux/plugins/tmux-continuum
fi

echo ""
echo "=== Linking configs ==="

# Git
echo "[git] Linking config..."
ln -sf "$DOTFILES/git/.gitconfig" ~/.gitconfig
echo "[git] Done"

# SSH
echo "[ssh] Linking config..."
mkdir -p ~/.ssh/sockets
ln -sf "$DOTFILES/ssh/config" ~/.ssh/config
chmod 600 ~/.ssh/config
echo "[ssh] Done"

# Claude Code
echo "[claude] Linking config..."
mkdir -p ~/.claude
ln -sf "$DOTFILES/claude/settings.json" ~/.claude/settings.json
ln -sf "$DOTFILES/claude/CLAUDE.md" ~/.claude/CLAUDE.md
echo "[claude] Done"

# Neovim
echo "[nvim] Linking config..."
mkdir -p ~/.config
if [ -d ~/.config/nvim ] && [ ! -L ~/.config/nvim ]; then
  echo "[nvim] WARNING: existing nvim config backed up to $BACKUP_DIR"
fi
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

# Scripts
echo "[scripts] Linking scripts..."
mkdir -p ~/.local/bin
ln -sf "$DOTFILES/scripts/cheatsheet.sh" ~/.local/bin/cheatsheet.sh
ln -sf "$DOTFILES/scripts/sessionizer.sh" ~/.local/bin/sessionizer.sh
chmod +x "$DOTFILES/scripts/cheatsheet.sh" "$DOTFILES/scripts/sessionizer.sh"
echo "[scripts] Done"

echo ""
echo "=== All done! ==="
echo "[info] Backup saved at: $BACKUP_DIR"
echo "Restart tmux: tmux source ~/.tmux.conf"
echo "Restart nvim: just open nvim"
echo "Reload zsh: source ~/.zshrc"
