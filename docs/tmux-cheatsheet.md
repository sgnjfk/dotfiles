# Tmux Cheatsheet

> Prefix hiện tại: `Ctrl+a` (đã đổi từ Ctrl+b)

## Session
| Key / Command          | Action              |
|------------------------|---------------------|
| `tmux new -s name`     | Tạo session mới     |
| `tmux ls`              | Liệt kê sessions    |
| `tmux attach -t name`  | Attach vào session   |
| `tmux kill-session -t name` | Xóa session    |
| `Ctrl+a $`             | Rename session       |
| `Ctrl+a d`             | Detach (thoát giữ session) |
| `Ctrl+a s`             | Chọn session         |

## Pane
| Key                    | Action              |
|------------------------|---------------------|
| `Ctrl+a |`             | Split dọc           |
| `Ctrl+a -`             | Split ngang         |
| `Ctrl+a x`             | Đóng pane (confirm) |
| `Alt+h/j/k/l`          | Chuyển pane (ko cần prefix) |
| `Ctrl+a z`             | Zoom pane (full screen toggle) |
| `Ctrl+a Space`         | Đổi layout          |
| `Ctrl+a : resize-pane -D/U/L/R N` | Resize N cells |
| `Ctrl+a : split-window -v -f` | Pane ngang full width |

> Pane active sáng bình thường, pane inactive tối hơn.

## Window (Tab)
| Key                    | Action              |
|------------------------|---------------------|
| `Ctrl+a c`             | Tạo window mới      |
| `Ctrl+a ,`             | Rename window        |
| `Ctrl+a n` / `Ctrl+a p` | Window tiếp/trước  |
| `Ctrl+a 1-9`           | Nhảy tới window N   |
| `Ctrl+a &`             | Đóng window          |
| `Ctrl+a w`             | Chọn window (list)   |

## Copy mode (vi-style)
| Key                    | Action              |
|------------------------|---------------------|
| `Ctrl+a [`             | Vào copy mode       |
| `h j k l`              | Di chuyển           |
| `/`                    | Tìm text            |
| `v`                    | Bắt đầu select     |
| `y`                    | Copy (vào clipboard Windows) |
| `Ctrl+a ]`             | Paste               |
| `q` / `Esc`            | Thoát copy mode     |

> Hoặc dùng chuột: bôi đen + `Ctrl+C` để copy.

## Khác
| Key / Command          | Action              |
|------------------------|---------------------|
| `Ctrl+a r`             | Reload config       |
| `Ctrl+a ?`             | Xem tất cả keybindings |
| `Ctrl+a t`             | Hiện đồng hồ       |
| Mouse                  | Đã bật (click, drag, scroll) |
