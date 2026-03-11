# SSH & Mosh Cheatsheet

## Kết nối
| Lệnh | Action |
|------|--------|
| `ssh user@host` | SSH |
| `ssh my-server` | Dùng alias |
| `mosh user@host` | Mosh (tự reconnect) |
| `ssh -p 2222 user@host` | Port khác |

## SSH Key
| Lệnh | Action |
|------|--------|
| `ssh-keygen -t ed25519` | Tạo key |
| `ssh-copy-id user@host` | Copy key lên server |
| `cat ~/.ssh/id_ed25519.pub` | Xem public key |

## Copy file
| Lệnh | Action |
|------|--------|
| `scp file user@host:/path/` | Upload |
| `scp user@host:/path/file .` | Download |
| `scp -r folder/ user@host:/path/` | Upload folder |

## Tunnel
| Lệnh | Action |
|------|--------|
| `ssh -L 8080:localhost:3000 user@host` | Port forward |
| `ssh -D 1080 user@host` | SOCKS proxy |

## SSH Config (`~/.ssh/config`)
```
Host my-server
    HostName 123.456.789.0
    User root
    IdentityFile ~/.ssh/id_ed25519
```
Sau đó: `ssh my-server`

## Connection
| Lệnh | Action |
|------|--------|
| `ssh -O check host` | Check connection |
| `ssh -O exit host` | Đóng connection |

## Mosh vs SSH
| | SSH | Mosh |
|--|-----|------|
| Mạng đứt | Mất | Tự reconnect |
| Đổi IP | Mất | Vẫn sống |
| Port forward | Có | Không |
