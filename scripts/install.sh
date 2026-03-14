#!/bin/bash
set -e

DOTFILES="$HOME/dotfiles"
IS_WSL=$(grep -qi microsoft /proc/version 2>/dev/null && echo true || echo false)
ARCH=$(uname -m)

echo "=== Dotfiles Install ==="
echo "[info] WSL detected: $IS_WSL"
echo "[info] Architecture: $ARCH"

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
sudo apt-get install -y -qq \
  tmux git curl unzip wget python3-pip pipx \
  ripgrep fd-find fzf zoxide \
  bat mosh jq ncdu btop \
  build-essential

# WSL vs native Linux packages
if [ "$IS_WSL" = true ]; then
  sudo apt-get install -y -qq wslu
else
  sudo apt-get install -y -qq xclip
fi

# Symlinks for Ubuntu-specific binary names
[ ! -f ~/.local/bin/bat ] && mkdir -p ~/.local/bin && ln -sf /usr/bin/batcat ~/.local/bin/bat
[ ! -f ~/.local/bin/fd ] && mkdir -p ~/.local/bin && ln -sf /usr/bin/fdfind ~/.local/bin/fd

# eza (not in apt on all Ubuntu versions)
if ! command -v eza &>/dev/null; then
  echo "[deps] Installing eza..."
  sudo mkdir -p /etc/apt/keyrings
  wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
  echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list > /dev/null
  sudo chmod 644 /etc/apt/keyrings/gierens.gpg /etc/apt/sources.list.d/gierens.list
  sudo apt-get update -qq && sudo apt-get install -y -qq eza
fi

# duf
if ! command -v duf &>/dev/null; then
  echo "[deps] Installing duf..."
  DUF_VERSION=$(curl -s https://api.github.com/repos/muesli/duf/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
  if [ "$ARCH" = "aarch64" ]; then
    DUF_ARCH="arm64"
  else
    DUF_ARCH="amd64"
  fi
  curl -Lo /tmp/duf.deb "https://github.com/muesli/duf/releases/latest/download/duf_${DUF_VERSION}_linux_${DUF_ARCH}.deb"
  sudo dpkg -i /tmp/duf.deb && rm /tmp/duf.deb
fi

# tldr
if ! command -v tldr &>/dev/null; then
  echo "[deps] Installing tldr..."
  sudo apt-get install -y -qq tldr 2>/dev/null || pipx install tldr --quiet 2>/dev/null || pip3 install --break-system-packages tldr --quiet
fi

# thefuck
if ! command -v thefuck &>/dev/null; then
  echo "[deps] Installing thefuck..."
  pipx install thefuck --quiet 2>/dev/null || pip3 install --break-system-packages thefuck --quiet
fi

# Lazygit
if ! command -v lazygit &>/dev/null; then
  echo "[deps] Installing lazygit..."
  LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
  if [ "$ARCH" = "aarch64" ]; then
    LAZYGIT_ARCH="arm64"
  else
    LAZYGIT_ARCH="x86_64"
  fi
  curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_${LAZYGIT_ARCH}.tar.gz"
  cd /tmp && tar xzf lazygit.tar.gz lazygit && sudo install lazygit /usr/local/bin/ && rm lazygit lazygit.tar.gz
  cd -
fi

# Dust
if ! command -v dust &>/dev/null; then
  echo "[deps] Installing dust..."
  DUST_VERSION=$(curl -s https://api.github.com/repos/bootandy/dust/releases/latest | grep -Po '"tag_name": "v\K[^"]*')
  if [ "$ARCH" = "aarch64" ]; then
    DUST_ARCH="arm64"
  else
    DUST_ARCH="amd64"
  fi
  curl -Lo /tmp/dust.deb "https://github.com/bootandy/dust/releases/latest/download/du-dust_${DUST_VERSION}-1_${DUST_ARCH}.deb"
  sudo dpkg -i /tmp/dust.deb && rm /tmp/dust.deb
fi

# Glow (markdown renderer)
if ! command -v glow &>/dev/null; then
  echo "[deps] Installing glow..."
  sudo mkdir -p /etc/apt/keyrings
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
  sudo apt-get update -qq && sudo apt-get install -y -qq glow
fi

# Neovim (latest)
echo "[nvim] Installing latest neovim..."
if [ "$ARCH" = "aarch64" ]; then
  NVIM_ARCH="arm64"
else
  NVIM_ARCH="x86_64"
fi
curl -LO "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz"
tar xzf "nvim-linux-${NVIM_ARCH}.tar.gz"
sudo cp -rf "nvim-linux-${NVIM_ARCH}"/* /usr/local/
rm -rf "nvim-linux-${NVIM_ARCH}" "nvim-linux-${NVIM_ARCH}.tar.gz"
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

# Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "[zsh] Installing oh-my-zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# Zsh plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-completions" ]; then
  git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"
fi

# Powerlevel10k
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  echo "[zsh] Installing powerlevel10k..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# NVM + Node LTS
if [ ! -d "$HOME/.nvm" ]; then
  echo "[nvm] Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
if ! command -v node &>/dev/null; then
  echo "[nvm] Installing Node LTS..."
  nvm install --lts
fi

# AI CLI tools (requires node, skip on ARM — heavy and rarely used on Pi)
if [ "$ARCH" != "aarch64" ]; then
  echo "[ai] Installing AI CLI tools..."
  command -v claude &>/dev/null || npm install -g @anthropic-ai/claude-code --quiet
  command -v codex &>/dev/null || npm install -g @openai/codex --quiet
  command -v gemini &>/dev/null || npm install -g @google/gemini-cli --quiet
else
  echo "[ai] Skipping AI CLI tools on ARM"
fi

# Set zsh as default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "[zsh] Setting zsh as default shell..."
  sudo chsh -s "$(which zsh)" "$USER"
fi

# Project directories
mkdir -p ~/projects ~/work

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
echo "[zsh] Linking config..."
ln -sf "$DOTFILES/zsh/.zshrc" ~/.zshrc
ln -sf "$DOTFILES/zsh/.p10k.zsh" ~/.p10k.zsh
echo "[zsh] Done"

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
echo "Restart shell: exec zsh"
echo "Start tmux: tmux"
echo "Open nvim: nvim (wait ~2min for plugins to install)"
