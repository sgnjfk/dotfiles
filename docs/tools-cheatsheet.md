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

## bat (`cat` có highlight)

| Command | Action |
|---------|--------|
| `cat file.py` | Xem file (đã alias, có syntax highlight) |
| `catn file.py` | Xem file + line numbers + header |
| `cat -l json file` | Chỉ định ngôn ngữ highlight |

## eza (`ls` đẹp hơn)

| Command | Action |
|---------|--------|
| `ls` | List file có icon (đã alias) |
| `ll` | List chi tiết + hidden files |
| `tree` | Tree view có icon |
| `tree -L 2` | Tree view giới hạn 2 cấp |

## btop (System Monitor)

| Key | Action |
|-----|--------|
| `btop` | Mở monitor |
| `h/l` | Chuyển tab |
| `f` | Filter process |
| `k` | Kill process |
| `s` | Sort |
| `q` | Thoát |

## dust (Disk Usage)

| Command | Action |
|---------|--------|
| `dust` | Xem dung lượng folder hiện tại |
| `dust -r` | Đảo ngược (nhỏ nhất trước) |
| `dust -n 5` | Chỉ hiện top 5 |
| `dust ~/Projects` | Xem folder cụ thể |

## duf (Disk Free)

| Command | Action |
|---------|--------|
| `duf` | Xem dung lượng tất cả ổ đĩa |

## tldr (Man page ngắn gọn)

| Command | Action |
|---------|--------|
| `tldr tar` | Xem ví dụ dùng tar |
| `tldr git commit` | Xem ví dụ git commit |
| `tldr --update` | Cập nhật database |

## ncdu (Interactive Disk Usage)

| Key | Action |
|-----|--------|
| `ncdu` | Scan folder hiện tại |
| `ncdu /path` | Scan folder cụ thể |
| Arrow / hjkl | Di chuyển |
| `Enter` | Vào subfolder |
| `d` | Xóa file/folder |
| `n` | Sort theo tên |
| `s` | Sort theo size |
| `q` | Thoát |

## thefuck

Gõ sai lệnh → gõ `fuck` → tự sửa.

```bash
git brnach        # gõ sai
fuck              # → git branch
```

## jq (JSON Processor)

| Command | Action |
|---------|--------|
| `cat file.json \| jq .` | Format JSON đẹp |
| `cat file.json \| jq '.name'` | Lấy field name |
| `cat file.json \| jq '.items[]'` | Duyệt array |
| `cat file.json \| jq '.items[] \| .id'` | Lấy id từ mỗi item |
| `curl api.com \| jq .` | Format API response |

## neofetch

```bash
neofetch          # Hiện system info đẹp
```
