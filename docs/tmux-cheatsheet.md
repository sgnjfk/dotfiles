# Tmux

Prefix: `C-b`

## Session
`tmux new -s name` Tạo session mới
`tmux ls` List sessions
`tmux attach -t name` Attach vào session
`tmux kill-session -t name` Xóa session
`C-b $` Rename session
`C-b d` Detach session
`C-b s` Chọn session (có preview, gõ / để filter)

## Pane
`C-b |` Split pane dọc
`C-b -` Split pane ngang
`C-b _` Split pane ngang full width
`C-b x` Đóng pane
`Alt+hjkl` Chuyển pane
`C-b z` Zoom/unzoom pane
`C-b Space` Đổi layout pane

Active pane sáng, inactive tối.

## Window
`C-b c` Tạo window mới
`C-b ,` Rename window
`C-b n/p` Window tiếp/trước
`C-b 1-9` Nhảy tới window N
`C-b &` Đóng window
`C-b w` List tất cả windows (có preview, gõ / để filter)

## Copy mode (vi)
`C-b [` Vào copy mode
`hjkl` Di chuyển trong copy mode
`/` Tìm text trong copy mode
`v` Bắt đầu chọn text
`y` Copy text → clipboard
`C-b ]` Paste từ buffer
`q/Esc` Thoát copy mode

Hoặc: bôi chuột + Ctrl+C.

## Save/Restore session
`C-b C-s` Save session thủ công
`C-b C-r` Restore session
Auto save session mỗi 5 phút.
`tsave` Xem lần save session cuối
`tss` Save session ngay
