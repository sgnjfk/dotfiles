# Dotfiles

Dev environment setup: Neovim + Tmux + Zsh + Git + SSH + Claude Code trên WSL.

## Cài đặt

```bash
git clone https://github.com/sgnjfk/dotfiles ~/dotfiles
~/dotfiles/scripts/install.sh
source ~/.zshrc
```

Script tự cài: Neovim (latest), Tmux, Glow, wslu, win32yank, Mosh, Catppuccin tmux theme, rồi link tất cả config.

Lần đầu mở `nvim`, chờ ~1-2 phút để lazy.nvim cài plugins và Mason cài LSP servers.

## Cấu trúc

```
~/dotfiles/
├── nvim/              → ~/.config/nvim
│   ├── init.lua
│   └── lua/
│       ├── config/    (options, keymaps, autocmds)
│       └── plugins/   (colorscheme, editor, lsp)
├── tmux/
│   └── tmux.conf      → ~/.tmux.conf
├── zsh/
│   └── .zshrc         → ~/.zshrc
├── git/
│   └── .gitconfig     → ~/.gitconfig
├── ssh/
│   └── config         → ~/.ssh/config
├── claude/
│   ├── settings.json  → ~/.claude/settings.json
│   └── CLAUDE.md      → ~/.claude/CLAUDE.md
├── scripts/
│   ├── install.sh     (cài đặt + link config)
│   └── cheatsheet.sh  (xem cheatsheet)
└── docs/
    ├── nvim-cheatsheet.md
    ├── tmux-cheatsheet.md
    └── git-cheatsheet.md
```

## Cheatsheet

```bash
cs nvim    # xem nvim cheatsheet
cs tmux    # xem tmux cheatsheet
cs git     # xem git cheatsheet
cs ssh     # xem ssh cheatsheet
cs         # menu chọn
```

## Aliases

| Alias | Lệnh |
|-------|-------|
| `cs`  | Xem cheatsheet |
| `open`| Mở file bằng app Windows (wslview) |
| `cl`  | Clear terminal |
| `lg`  | Lazygit |
| `z folder` | Zoxide — smart cd |
| `zi`  | Zoxide interactive |
| `Ctrl+r` | fzf — tìm command history |
| `Ctrl+t` | fzf — tìm file |

## Git Aliases

| Alias | Lệnh |
|-------|-------|
| `git s` | `git status` |
| `git co` | `git checkout` |
| `git br` | `git branch` |
| `git cm "msg"` | `git commit -m "msg"` |
| `git lg` | Log dạng cây |
| `git last` | Xem commit cuối |
| `git undo` | Undo commit cuối |

## Neovim

**Theme:** Catppuccin Mocha (transparent)

**Phím tắt chính (Leader = Space):**

| Key | Action |
|-----|--------|
| `Space+e` | File explorer |
| `Space+ff` | Tìm file |
| `Space+fg` | Tìm text (grep) |
| `Space+fb` | Chuyển buffer |
| `Space+fr` | File gần đây |
| `gd` | Go to definition |
| `gr` | References |
| `K` | Hover docs |
| `Space+ca` | Code action |
| `Space+rn` | Rename |
| `Space+cf` | Format code |
| `gcc` | Comment/uncomment |
| `Ctrl+\` | Terminal float |
| `Shift+H/L` | Buffer trước/sau |

**LSP hỗ trợ:** Lua, TypeScript/JS, Python, HTML, CSS, Tailwind, JSON.

## Tmux

**Prefix:** `Ctrl+a` | **Theme:** Catppuccin Mocha

| Key | Action |
|-----|--------|
| `Ctrl+a \|` | Split dọc |
| `Ctrl+a -` | Split ngang |
| `Alt+h/j/k/l` | Chuyển pane |
| `Ctrl+a z` | Zoom pane |
| `Ctrl+a [` | Copy mode (vi-style) |
| `v` → `y` | Select → copy (clipboard Windows) |
| `Ctrl+a s` | Chọn session |
| `Ctrl+a r` | Reload config |

## SSH

- ControlMaster: dùng chung connection, connect lại tức thì
- ServerAliveInterval: heartbeat mỗi 60s, không bị timeout
- Mosh: `mosh user@server` — tự reconnect khi mạng đứt

## Claude Code

- Global rules: `claude/CLAUDE.md`
- Per-project rules: đặt `CLAUDE.md` trong thư mục project
- Per-project override global nếu conflict

## Thêm tool mới

1. Tạo folder trong `~/dotfiles/`
2. Copy config vào
3. Thêm symlink vào `scripts/install.sh`
4. Commit & push
