# Tmux

Prefix: `C-a`

## Session
`tmux new -s name` Tạo session mới
`tmux ls` List sessions
`tmux attach -t name` Attach vào session
`tmux kill-session -t name` Xóa session
`C-a $` Rename session
`C-a d` Detach session
`C-a s` Chọn session (picker)

## Pane
`C-a |` Split pane dọc
`C-a -` Split pane ngang
`C-a x` Đóng pane
`Alt+hjkl` Chuyển pane
`C-a z` Zoom/unzoom pane
`C-a Space` Đổi layout pane

Active pane sáng, inactive tối.

## Window
`C-a c` Tạo window mới
`C-a ,` Rename window
`C-a n/p` Window tiếp/trước
`C-a 1-9` Nhảy tới window N
`C-a &` Đóng window
`C-a w` List tất cả windows

## Copy mode (vi)
`C-a [` Vào copy mode
`hjkl` Di chuyển trong copy mode
`/` Tìm text trong copy mode
`v` Bắt đầu chọn text
`y` Copy text → clipboard
`C-a ]` Paste từ buffer
`q/Esc` Thoát copy mode

Hoặc: bôi chuột + Ctrl+C.

## Save/Restore session
`C-a C-s` Save session thủ công
`C-a C-r` Restore session
Auto save session mỗi 5 phút.
`tsave` Xem lần save session cuối
`tss` Save session ngay
