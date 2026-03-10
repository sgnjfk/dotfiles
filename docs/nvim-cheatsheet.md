# Neovim Cheatsheet

## Modes
| Key     | Mode     |
|---------|----------|
| `Esc`   | Normal   |
| `i`     | Insert (trước cursor) |
| `a`     | Insert (sau cursor)   |
| `v`     | Visual   |
| `V`     | Visual Line |
| `:`     | Command  |

## Di chuyển (Normal mode)
| Key        | Action              |
|------------|---------------------|
| `h j k l`  | Trái/Xuống/Lên/Phải |
| `w` / `b`  | Từ tiếp / từ trước  |
| `0` / `$`  | Đầu dòng / cuối dòng |
| `gg` / `G` | Đầu file / cuối file |
| `Ctrl+d/u` | Cuộn nửa trang xuống/lên |
| `{` / `}`  | Paragraph trước/sau |
| `%`        | Nhảy tới dấu ngoặc đối diện |

## Chỉnh sửa
| Key    | Action            |
|--------|-------------------|
| `i/a`  | Insert trước/sau cursor |
| `o/O`  | Dòng mới dưới/trên |
| `x`    | Xóa 1 ký tự       |
| `dd`   | Xóa dòng          |
| `yy`   | Copy dòng          |
| `p/P`  | Paste dưới/trên    |
| `u`    | Undo               |
| `Ctrl+r` | Redo            |
| `ciw`  | Đổi từ (change inner word) |
| `di"`  | Xóa trong dấu "   |
| `5dd`  | Xóa 5 dòng        |

## Lưu & Thoát
| Key         | Action       |
|-------------|--------------|
| `:w`        | Save         |
| `:q`        | Quit         |
| `:wq`       | Save & quit  |
| `:q!`       | Quit ko save |
| `Space+w`   | Save (shortcut) |
| `Space+q`   | Quit (shortcut) |

## Tìm kiếm
| Key         | Action              |
|-------------|---------------------|
| `Space+ff`  | Tìm file            |
| `Space+fg`  | Tìm text (grep)     |
| `Space+fb`  | Chuyển buffer       |
| `Space+fr`  | File gần đây        |
| `Space+/`   | Tìm trong file hiện tại |
| `/text`     | Tìm trong file      |
| `n` / `N`   | Kết quả tiếp / trước |

## LSP (Code Intelligence)
| Key         | Action              |
|-------------|---------------------|
| `gd`        | Go to definition    |
| `gr`        | References          |
| `gi`        | Implementation      |
| `K`         | Hover docs          |
| `Space+ca`  | Code action         |
| `Space+rn`  | Rename              |
| `Space+D`   | Type definition     |
| `Space+d`   | Line diagnostics    |
| `[d` / `]d` | Diagnostic trước/sau |
| `Space+cf`  | Format code         |

## File & Window
| Key         | Action              |
|-------------|---------------------|
| `Space+e`   | File explorer       |
| `Shift+H/L` | Buffer trước/sau   |
| `Space+bd`  | Đóng buffer         |
| `:vsplit`   | Split dọc           |
| `:split`    | Split ngang         |
| `Ctrl+h/j/k/l` | Chuyển pane      |

## Tiện ích
| Key         | Action              |
|-------------|---------------------|
| `gcc`       | Comment/uncomment dòng |
| `gc`        | Comment selection (visual) |
| `Ctrl+\`    | Terminal float      |
| `Space+th`  | Terminal ngang      |
| `Ctrl+a`    | Select all          |
| `Space`     | Which-key (chờ xem phím tắt) |

## Autocomplete (Insert mode)
| Key         | Action              |
|-------------|---------------------|
| `Tab`       | Chọn gợi ý tiếp    |
| `Shift+Tab` | Gợi ý trước        |
| `Enter`     | Confirm             |
| `Ctrl+Space`| Mở autocomplete     |
| `Ctrl+e`    | Đóng autocomplete   |
