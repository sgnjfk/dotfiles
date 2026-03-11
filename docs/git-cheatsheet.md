# Git Cheatsheet

## Setup
| Lệnh | Action |
|------|--------|
| `git init` | Tạo repo |
| `git clone <url>` | Clone |
| `git remote add origin <url>` | Thêm remote |

## Cơ bản
| Lệnh | Action |
|------|--------|
| `git s` | Status |
| `git add <file>` | Stage file |
| `git add .` | Stage all |
| `git cm "msg"` | Commit |
| `git push` | Push |
| `git pull` | Pull |
| `git fetch` | Fetch |

## Branch
| Lệnh | Action |
|------|--------|
| `git br` | Xem branches |
| `git br <name>` | Tạo branch |
| `git co <name>` | Chuyển branch |
| `git co -b <name>` | Tạo + chuyển |
| `git merge <branch>` | Merge |
| `git br -d <name>` | Xóa branch |

## Lịch sử
| Lệnh | Action |
|------|--------|
| `git lg` | Log cây |
| `git last` | Commit cuối |
| `git diff` | Xem thay đổi |
| `git diff --staged` | Đã stage |
| `git show <commit>` | Chi tiết commit |
| `git blame <file>` | Ai sửa dòng nào |

## Undo
| Lệnh | Action |
|------|--------|
| `git restore <file>` | Bỏ thay đổi |
| `git restore --staged <file>` | Unstage |
| `git commit --amend` | Sửa commit cuối |
| `git undo` | Undo commit cuối |
| `git reset --hard HEAD~1` | Undo + xóa |
| `git revert <commit>` | Đảo ngược |

## Stash
| Lệnh | Action |
|------|--------|
| `git stash` | Cất tạm |
| `git stash pop` | Lấy lại |
| `git stash list` | Danh sách |
| `git stash drop` | Xóa stash |

## Rebase
| Lệnh | Action |
|------|--------|
| `git rebase <branch>` | Rebase |
| `git rebase --continue` | Tiếp tục |
| `git rebase --abort` | Hủy |

## Remote
| Lệnh | Action |
|------|--------|
| `git remote -v` | Xem remotes |
| `git push -u origin <br>` | Push branch mới |
| `git push origin --delete <br>` | Xóa remote branch |

## GitHub CLI
| Lệnh | Action |
|------|--------|
| `gh repo create` | Tạo repo |
| `gh pr create` | Tạo PR |
| `gh pr list` | Xem PRs |
| `gh pr checkout <N>` | Checkout PR |
| `gh issue list` | Xem issues |

## Tips
- `git add -p` — stage từng phần
- `git cherry-pick <commit>` — copy commit
- `git reflog` — cứu khi lỡ tay
