# Tools Cheatsheet

## Lazygit (`lg`)

TUI git client — mọi thứ bằng phím tắt, không cần gõ lệnh.

| Key | Action |
|-----|--------|
| `Space` | Stage/unstage file |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `Enter` | Xem diff/chi tiết |
| `[` / `]` | Chuyển tab (Status, Files, Branches, Commits, Stash) |
| `a` | Stage all |
| `d` | Discard changes |
| `b` | Checkout branch |
| `n` | New branch |
| `M` | Merge |
| `r` | Rebase |
| `z` | Undo |
| `?` | Xem tất cả keybindings |
| `q` | Thoát |

## fzf (Fuzzy Finder)

Tìm kiếm mờ — gõ vài ký tự là match.

| Key | Action |
|-----|--------|
| `Ctrl+r` | Tìm trong command history |
| `Ctrl+t` | Tìm file trong folder hiện tại |
| `Alt+c` | cd vào subfolder |

Trong fzf:
| Key | Action |
|-----|--------|
| Gõ text | Filter kết quả |
| `Ctrl+j/k` | Di chuyển lên/xuống |
| `Enter` | Chọn |
| `Esc` | Thoát |
| `Tab` | Chọn nhiều (multi-select) |

Kết hợp với pipe:
```bash
cat file.txt | fzf          # tìm trong file
git branch | fzf             # chọn branch
kill -9 $(ps aux | fzf)      # chọn process để kill
```

## zoxide (Smart cd)

Nhớ folder bạn hay vào, càng dùng càng thông minh.

| Command | Action |
|---------|--------|
| `z foo` | Nhảy tới folder có chứa "foo" |
| `z foo bar` | Nhảy tới folder match cả "foo" và "bar" |
| `zi` | Interactive — chọn từ danh sách |
| `z -` | Quay lại folder trước |

Ví dụ:
```bash
cd ~/Projects/my-app     # lần đầu dùng cd bình thường
z my                     # lần sau chỉ cần gõ vậy
z app                    # hoặc vậy, cũng nhảy tới
```

## Glow (Markdown Viewer)

| Command | Action |
|---------|--------|
| `glow file.md` | Render markdown |
| `glow -p file.md` | Pager mode (cuộn được) |
| `glow .` | Xem tất cả markdown trong folder |
