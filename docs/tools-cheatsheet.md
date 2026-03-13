# Tools

## Lazygit (`lg`)
`Space` Stage/unstage file trong lazygit
`c` Commit trong lazygit
`p` Push trong lazygit
`P` Pull trong lazygit
`Enter` Xem diff trong lazygit
`[/]` Chuyển tab trong lazygit
`a` Stage all trong lazygit
`d` Discard changes trong lazygit
`b` Checkout branch trong lazygit
`n` Tạo branch mới trong lazygit
`z` Undo trong lazygit
`?` Mở help lazygit
`q` Thoát lazygit

## fzf
`C-r` Tìm command history (fzf)
`C-t` Tìm file (fzf)
`Alt+c` cd vào subfolder (fzf)
`C-j/k` Di chuyển lên/xuống trong fzf
`Enter` Chọn kết quả fzf
`Esc` Thoát fzf
`Tab` Multi-select trong fzf

## zoxide
`z foo` Nhảy tới folder chứa "foo"
`z foo bar` Nhảy tới folder match cả hai
`zi` Chọn folder interactive (zoxide)
`z -` Quay lại folder trước (zoxide)

## glow (render markdown)
`glow file.md` Render markdown ra terminal
`glow -p file.md` Render markdown có pager

## bat (`cat` với syntax highlight)
`cat file` Xem file có syntax highlight (bat)
`catn file` Xem file có line numbers (bat)

## eza (`ls` với icons)
`ls` List file có icons (eza)
`ll` List chi tiết + hidden files (eza)
`tree` Tree view folder (eza)
`tree -L 2` Tree view 2 cấp (eza)

## btop (system monitor)
`btop` Mở system monitor
`f` Filter process trong btop
`k` Kill process trong btop
`q` Thoát btop

## dust/duf/ncdu (disk usage)
`dust` Xem dung lượng folder (tree)
`duf` Xem dung lượng ổ đĩa
`ncdu` Xem dung lượng interactive (xóa được)

## tldr (man page ngắn gọn)
`tldr tar` Xem ví dụ lệnh tar
`tldr --update` Cập nhật database tldr

## thefuck (tự sửa lệnh sai)
Gõ sai lệnh → `fuck` → tự sửa lệnh

## jq (xử lý JSON)
`cat f.json | jq .` Format JSON
`cat f.json | jq '.name'` Lấy 1 field từ JSON
`cat f.json | jq '.items[]'` Lấy array từ JSON
`curl api | jq .` Format JSON từ API

## AI quick query
`ask "câu hỏi"` Hỏi Claude (non-interactive)
`askg "câu hỏi"` Hỏi Gemini (non-interactive)
`askx "câu hỏi"` Hỏi Codex (non-interactive)

## opw (mở file/folder trên Windows từ Linux)
`opw file.pdf` Mở file trên Windows
`opw file.md` Render markdown trên browser (có chọn theme)
`opw folder/` Serve folder — danh sách file với View / Download
`opw a.xlsx b.docx` Mở nhiều file cùng lúc
View: .md .html .pdf .txt ảnh — mở inline trên browser
Download: tất cả file, kể cả viewable
MD themes: GitHub Dark, GitHub Light, Catppuccin, Dracula, Solarized Dark
Theme lưu vào localStorage — tự nhớ lần sau
Ctrl+C để tắt server

## clip (copy vào clipboard Windows)
`echo "text" | clip` Copy text vào clipboard Windows
`cat file.txt | clip` Copy nội dung file vào clipboard
Hoạt động trong tmux (bypass qua SSH TTY gốc).

## Cheatsheet
`cs tmux` Xem cheatsheet (glow)
`csf rename session` Tìm nhanh trong cheatsheet (fzf)
