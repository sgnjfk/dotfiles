# SSH & Mosh Cheatsheet

## Kết nối
| Command | Action |
|---------|--------|
| `ssh user@host` | Kết nối SSH |
| `ssh my-server` | Kết nối bằng alias (từ ~/.ssh/config) |
| `mosh user@host` | Kết nối Mosh (tự reconnect) |
| `ssh -p 2222 user@host` | Kết nối port khác |

## SSH Key
| Command | Action |
|---------|--------|
| `ssh-keygen -t ed25519` | Tạo key mới |
| `ssh-copy-id user@host` | Copy public key lên server |
| `cat ~/.ssh/id_ed25519.pub` | Xem public key |

## Copy file
| Command | Action |
|---------|--------|
| `scp file.txt user@host:/path/` | Upload file |
| `scp user@host:/path/file.txt .` | Download file |
| `scp -r folder/ user@host:/path/` | Upload folder |

## Tunnel
| Command | Action |
|---------|--------|
| `ssh -L 8080:localhost:3000 user@host` | Forward port (local 8080 → remote 3000) |
| `ssh -D 1080 user@host` | SOCKS proxy |

## SSH Config (`~/.ssh/config`)
```
Host my-server
    HostName 123.456.789.0
    User root
    IdentityFile ~/.ssh/id_ed25519
    Port 22
```
Sau đó chỉ cần: `ssh my-server`

## Quản lý connection
| Command | Action |
|---------|--------|
| `ssh -O check my-server` | Kiểm tra connection đang mở |
| `ssh -O exit my-server` | Đóng shared connection |
| `ls ~/.ssh/sockets/` | Xem các connection đang active |

## Mosh vs SSH
| | SSH | Mosh |
|--|-----|------|
| Mạng ổn | Tốt | Tốt |
| Mạng đứt | Mất kết nối | Tự reconnect |
| Đổi IP/wifi | Mất kết nối | Vẫn sống |
| Port forwarding | Có | Không |
| Server cần cài | Không | Cần `mosh-server` |
