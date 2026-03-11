# Neovim

## Modes
`Esc` Về Normal mode
`i` Insert trước cursor
`a` Insert sau cursor
`v` Visual mode (chọn ký tự)
`V` Visual Line mode (chọn dòng)
`:` Command mode

## Di chuyển
`hjkl` Trái/Xuống/Lên/Phải
`w/b` Nhảy từ tiếp/trước
`0/$` Đầu dòng/cuối dòng
`gg/G` Đầu file/cuối file
`C-d/u` Nửa trang xuống/lên
`{/}` Paragraph trước/sau
`%` Nhảy ngoặc đối diện

## Chỉnh sửa
`i/a` Insert trước/sau cursor
`o/O` Thêm dòng mới dưới/trên
`x` Xóa 1 ký tự
`dd` Xóa 1 dòng
`5dd` Xóa 5 dòng
`yy` Copy dòng
`p/P` Paste dưới/trên cursor
`u` Undo
`C-r` Redo
`ciw` Đổi nội dung 1 từ
`di"` Xóa nội dung trong ""

## Lưu & Thoát
`:w` Save file
`:q` Quit nvim
`:wq` Save và quit
`:q!` Quit không save
`SPC w` Save file (shortcut)
`SPC q` Quit nvim (shortcut)

## Tìm kiếm
`SPC ff` Tìm file (Telescope)
`SPC fg` Grep text toàn project
`SPC fb` Chuyển buffer (Telescope)
`SPC fr` File mở gần đây
`SPC /` Tìm text trong project
`/text` Tìm text trong file hiện tại
`n/N` Kết quả tìm tiếp/trước

## LSP
`gd` Đi tới definition
`gr` Xem references
`gi` Đi tới implementation
`K` Hover xem docs
`SPC ca` Code action
`SPC rn` Rename symbol
`SPC D` Type definition
`SPC d` Xem diagnostics
`[d/]d` Diagnostic trước/sau
`SPC cf` Format code

## File & Window
`SPC e` Mở file explorer (Neo-tree)
`S-H/S-L` Buffer trước/sau
`SPC bd` Đóng buffer hiện tại
`:vsplit` Split window dọc
`:split` Split window ngang
`C-hjkl` Chuyển giữa các window

## Tiện ích
`gcc` Comment/uncomment 1 dòng
`gc` Comment/uncomment vùng chọn
`C-\` Mở terminal float
`SPC th` Mở terminal ngang
`C-a` Select all text
`SPC` Mở Which-key (xem phím tắt)
`nview file` Mở file read-only

## Autocomplete
`Tab` Gợi ý autocomplete tiếp
`S-Tab` Gợi ý autocomplete trước
`Enter` Chọn gợi ý autocomplete
`C-Space` Mở menu autocomplete
`C-e` Đóng menu autocomplete
