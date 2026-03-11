# Tools Cheatsheet

## Lazygit (`lg`)
| Key | Action |
|-----|--------|
| `Space` | Stage/unstage |
| `c` | Commit |
| `p` | Push |
| `P` | Pull |
| `Enter` | Xem diff |
| `[` / `]` | Chuyển tab |
| `a` | Stage all |
| `d` | Discard |
| `b` | Checkout branch |
| `n` | New branch |
| `z` | Undo |
| `?` | Help |
| `q` | Thoát |

## fzf
| Key | Action |
|-----|--------|
| `C-r` | Tìm history |
| `C-t` | Tìm file |
| `Alt+c` | cd subfolder |
| `C-j/k` | Lên/xuống |
| `Enter` | Chọn |
| `Esc` | Thoát |
| `Tab` | Multi-select |

```bash
cat file | fzf        # tìm trong file
git branch | fzf      # chọn branch
```

## zoxide
| Lệnh | Action |
|------|--------|
| `z foo` | Nhảy tới "foo" |
| `z foo bar` | Match cả hai |
| `zi` | Interactive |
| `z -` | Folder trước |

## glow
| Lệnh | Action |
|------|--------|
| `glow file.md` | Render |
| `glow -p file.md` | Pager mode |

## bat (`cat`)
| Lệnh | Action |
|------|--------|
| `cat file` | Highlight |
| `catn file` | + line numbers |

## eza (`ls`)
| Lệnh | Action |
|------|--------|
| `ls` | List + icon |
| `ll` | Chi tiết + hidden |
| `tree` | Tree view |
| `tree -L 2` | 2 cấp |

## btop
| Key | Action |
|-----|--------|
| `btop` | Mở monitor |
| `f` | Filter |
| `k` | Kill process |
| `q` | Thoát |

## dust / duf / ncdu
| Lệnh | Action |
|------|--------|
| `dust` | Dung lượng folder |
| `dust -n 5` | Top 5 |
| `duf` | Dung lượng ổ đĩa |
| `ncdu` | Interactive (xóa được) |

## tldr
| Lệnh | Action |
|------|--------|
| `tldr tar` | Ví dụ dùng tar |
| `tldr --update` | Cập nhật |

## thefuck
```bash
git brnach    # gõ sai
fuck          # → git branch
```

## jq
| Lệnh | Action |
|------|--------|
| `cat f.json \| jq .` | Format |
| `cat f.json \| jq '.name'` | Lấy field |
| `cat f.json \| jq '.items[]'` | Duyệt array |
| `curl api \| jq .` | Format API |
