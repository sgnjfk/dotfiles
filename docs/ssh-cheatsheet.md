# SSH & Mosh

## Kết nối
`ssh user@host` Kết nối SSH tới server
`ssh my-server` Kết nối SSH dùng alias
`mosh user@host` Kết nối Mosh (tự reconnect)
`ssh -p 2222 user@host` SSH qua port khác

## Key
`ssh-keygen -t ed25519` Tạo SSH key mới
`ssh-copy-id user@host` Copy public key lên server
`cat ~/.ssh/id_ed25519.pub` Xem public key

## Copy file qua SSH
`scp file user@host:/path/` Upload file lên server
`scp user@host:/path/f .` Download file từ server
`scp -r dir/ user@host:/p/` Upload cả folder

## Tunnel
`ssh -L 8080:localhost:3000 host` Forward local:8080 tới remote:3000
`ssh -D 1080 host` Tạo SOCKS proxy qua SSH

## Config (~/.ssh/config)
```
Host my-server
    HostName 1.2.3.4
    User root
    IdentityFile ~/.ssh/id_ed25519
```
Sau đó: `ssh my-server`

## Mosh vs SSH
Mạng đứt: SSH mất kết nối, Mosh tự reconnect
Đổi IP/wifi: SSH mất, Mosh vẫn sống
Port forward/tunnel: chỉ SSH hỗ trợ
