# Dotfiles

Dev environment setup: Neovim + Tmux + Zsh trên WSL.

## Cài đặt

```bash
git clone https://github.com/sgnjfk/dotfiles ~/dotfiles
~/dotfiles/scripts/install.sh
source ~/.zshrc
```

Script sẽ tự cài: Neovim (latest), Tmux, Glow, wslu, win32yank, Catppuccin tmux theme, rồi link tất cả config.

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
cs         # menu chọn
```

## Aliases

| Alias | Lệnh |
|-------|-------|
| `cs`  | Xem cheatsheet |
| `open`| Mở file bằng app Windows (wslview) |
| `cl`  | Clear terminal |

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

**Prefix:** `Ctrl+a`

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

## Thêm tool mới

1. Tạo folder trong `~/dotfiles/`
2. Thêm symlink vào `scripts/install.sh`
3. Commit & push
