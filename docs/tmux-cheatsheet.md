# Tmux Cheatsheet

> Prefix: `C-a`

## Session
| Lệnh | Action |
|------|--------|
| `tmux new -s name` | Tạo session |
| `tmux ls` | List sessions |
| `tmux attach -t name` | Attach |
| `tmux kill-session -t name` | Xóa |
| `C-a $` | Rename session |
| `C-a d` | Detach |
| `C-a s` | Chọn session |

## Pane
| Key | Action |
|-----|--------|
| `C-a \|` | Split dọc |
| `C-a -` | Split ngang |
| `C-a x` | Đóng pane |
| `Alt+h/j/k/l` | Chuyển pane |
| `C-a z` | Zoom toggle |
| `C-a Space` | Đổi layout |
| `C-a : resize-pane -D/U/L/R N` | Resize |
| `C-a : split-window -v -f` | Full-width split |

> Active pane sáng, inactive tối.

## Window
| Key | Action |
|-----|--------|
| `C-a c` | Tạo window |
| `C-a ,` | Rename |
| `C-a n` / `C-a p` | Tiếp / trước |
| `C-a 1-9` | Nhảy tới N |
| `C-a &` | Đóng window |
| `C-a w` | List windows |

## Copy mode (vi)
| Key | Action |
|-----|--------|
| `C-a [` | Vào copy mode |
| `h j k l` | Di chuyển |
| `/` | Tìm text |
| `v` | Bắt đầu chọn |
| `y` | Copy → clipboard |
| `C-a ]` | Paste |
| `q` / `Esc` | Thoát |

> Hoặc: bôi chuột + `Ctrl+C`.

## Save/Restore
| Key | Action |
|-----|--------|
| `C-a C-s` | Save thủ công |
| `C-a C-r` | Restore |
| Auto save | Mỗi 5 phút |
| Auto restore | Khi mở tmux |
| `tsave` | Xem lần save cuối |
| `tss` | Save ngay |

## Khác
| Key | Action |
|-----|--------|
| `C-a r` | Reload config |
| `C-a ?` | Tất cả keybindings |
| `C-a t` | Đồng hồ |
