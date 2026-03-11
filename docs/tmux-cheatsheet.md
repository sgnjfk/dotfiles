# Tmux

Prefix: `C-a`

## Session
`tmux new -s name` Tạo
`tmux ls` List
`tmux attach -t name` Attach
`tmux kill-session -t name` Xóa
`C-a $` Rename session
`C-a d` Detach
`C-a s` Chọn session

## Pane
`C-a |` Split dọc
`C-a -` Split ngang
`C-a x` Đóng pane
`Alt+hjkl` Chuyển pane
`C-a z` Zoom toggle
`C-a Space` Đổi layout

Active sáng, inactive tối.

## Window
`C-a c` Tạo window
`C-a ,` Rename
`C-a n/p` Tiếp/trước
`C-a 1-9` Nhảy tới N
`C-a &` Đóng
`C-a w` List windows

## Copy mode (vi)
`C-a [` Vào copy mode
`hjkl` Di chuyển
`/` Tìm text
`v` Bắt đầu chọn
`y` Copy → clipboard
`C-a ]` Paste
`q/Esc` Thoát

Hoặc: bôi chuột + Ctrl+C.

## Save/Restore
`C-a C-s` Save thủ công
`C-a C-r` Restore
Auto save mỗi 5 phút.
`tsave` Xem lần save cuối
`tss` Save ngay

## Khác
`C-a r` Reload config
`C-a ?` Tất cả keybindings
`C-a t` Đồng hồ
