# SSH & Mosh

## Kết nối
`ssh user@host` SSH
`ssh my-server` Dùng alias
`mosh user@host` Tự reconnect
`ssh -p 2222 user@host` Port khác

## Key
`ssh-keygen -t ed25519` Tạo key
`ssh-copy-id user@host` Copy lên server
`cat ~/.ssh/id_ed25519.pub` Xem

## Copy file
`scp file user@host:/path/` Upload
`scp user@host:/path/f .` Download
`scp -r dir/ user@host:/p/` Folder

## Tunnel
`ssh -L 8080:localhost:3000 host`
→ local:8080 tới remote:3000
`ssh -D 1080 host` SOCKS proxy

## Config (~/.ssh/config)
```
Host my-server
    HostName 1.2.3.4
    User root
    IdentityFile ~/.ssh/id_ed25519
```
Sau đó: `ssh my-server`

## Mosh vs SSH
Mạng đứt: SSH mất, Mosh reconnect
Đổi IP: SSH mất, Mosh sống
Port forward: chỉ SSH có
