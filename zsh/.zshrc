# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path
export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions history sudo)
source $ZSH/oh-my-zsh.sh

# NVM (lazy load, but keep node in PATH)
export NVM_DIR="$HOME/.nvm"
[ -d "$NVM_DIR/versions/node" ] && export PATH="$(find $NVM_DIR/versions/node -maxdepth 1 -type d | sort -V | tail -1)/bin:$PATH"
lazy_load_nvm() {
  unset -f nvm node npm npx
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}
nvm() { lazy_load_nvm; nvm "$@"; }
node() { lazy_load_nvm; node "$@"; }
npm() { lazy_load_nvm; npm "$@"; }
npx() { lazy_load_nvm; npx "$@"; }

# envman
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# OpenClaw
[[ -f "/home/vp/.openclaw/completions/openclaw.zsh" ]] && source "/home/vp/.openclaw/completions/openclaw.zsh"

# fzf
source /usr/share/doc/fzf/examples/key-bindings.zsh
source /usr/share/doc/fzf/examples/completion.zsh

# zoxide
eval "$(zoxide init zsh)"

# Autosuggestion accept
bindkey '^ ' autosuggest-accept

# thefuck (lazy load)
fuck() {
  eval "$(thefuck --alias)"
  fuck "$@"
}

# ===== Aliases =====
alias cs="$HOME/dotfiles/scripts/cheatsheet.sh"
alias ss="$HOME/dotfiles/scripts/sessionizer.sh"
csf() { grep -H '.' ~/dotfiles/docs/*-cheatsheet.md | sed 's|.*/\(.*\)-cheatsheet.md:|\1: |' | fzf --query="$*"; }
alias open="wslview"
alias cl="clear"
alias lg="lazygit"
alias cat="batcat --style=plain"
alias catn="batcat"
alias ls="eza --icons"
alias ll="eza --icons -la"
alias tree="eza --icons --tree"
alias nview="nvim -R"
alias tsave="ls -la ~/.local/share/tmux/resurrect/last"
alias tss="tmux run-shell ~/.config/tmux/plugins/tmux-resurrect/scripts/save.sh && echo 'Session saved!' && tsave"

# AI quick query (non-interactive)
ask() { claude -p "$*" --allowedTools "WebSearch,WebFetch" | glow -; }
askg() { gemini -p "$*" -o text --yolo 2>/dev/null | glow -; }
askx() { codex exec --skip-git-repo-check "$*" 2>&1 | grep -v "^OpenAI\|^---\|^workdir\|^model\|^provider\|^approval\|^sandbox\|^reasoning\|^session\|^user\|^mcp\|^tokens" | glow -; }
