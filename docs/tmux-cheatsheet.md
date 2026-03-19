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
`C-b w` Chọn session/window dạng tree (preview pane, j/k navigate, / filter)
`C-f` Sessionizer — tìm folder, tạo/switch session (fzf)
`ss` Sessionizer từ terminal

## Window
`C-b c` Tạo window mới
`C-b ,` Rename window
`C-b n/p` Window tiếp/trước
`C-b 1-9` Nhảy tới window N
`C-b &` Đóng window
`C-b :swap-window -t -1` Đổi vị trí window sang trái
`C-b :swap-window -t +1` Đổi vị trí window sang phải

## Pane
`C-b |` Split pane dọc
`C-b -` Split pane ngang
`C-b _` Split pane ngang full width
`C-b x` Đóng pane
`Alt+hjkl` Chuyển pane
`C-b z` Zoom/unzoom pane (focus 1 pane full screen)
`C-b Space` Cycle layout (even-horizontal, even-vertical, tiled, ...)
`C-b q` Hiện số pane — bấm số để nhảy tới
`C-b !` Tách pane thành window riêng
`C-b {` / `C-b }` Swap pane trái/phải
`C-b m` Mark pane (dùng để swap/join với pane khác)
`C-b :join-pane -t <session>:<window>` Move pane sang window/session khác
`C-b :move-window -t <session>:` Move window sang session khác

Active pane sáng, inactive tối.

## Copy mode (vi)
`C-b [` Vào copy mode
`hjkl` Di chuyển
`/` Tìm text (như vim)
`?` Tìm ngược
`n/N` Next/prev match
`v` Bắt đầu chọn text
`y` Copy text → clipboard
`C-b ]` Paste từ buffer
`q/Esc` Thoát copy mode

Hoặc: giữ Shift + kéo chuột để select bình thường (bypass tmux).

## Commands hữu ích (`C-b :` rồi nhập)
`capture-pane -S -1000 -p` Dump 1000 dòng scrollback ra stdout
`pipe-pane -o 'cat >> log.txt'` Log output pane ra file
`pipe-pane` Tắt pipe (chạy lại không argument)

## Tiện ích
`C-b t` Đồng hồ to
`C-b r` Reload config

## Save/Restore session
`C-b C-s` Save session thủ công
`C-b C-r` Restore session
Auto save session mỗi 5 phút.
`tsave` Xem lần save session cuối
`tss` Save session ngay
