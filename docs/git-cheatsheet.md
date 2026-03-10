# Git Cheatsheet

## Setup
| Command | Action |
|---------|--------|
| `git init` | Tạo repo mới |
| `git clone <url>` | Clone repo |
| `git remote add origin <url>` | Thêm remote |

## Cơ bản
| Command | Action |
|---------|--------|
| `git status` | Xem trạng thái |
| `git add <file>` | Stage file |
| `git add .` | Stage tất cả |
| `git commit -m "msg"` | Commit |
| `git push` | Push lên remote |
| `git pull` | Pull về |
| `git fetch` | Fetch (không merge) |

## Branch
| Command | Action |
|---------|--------|
| `git branch` | Xem branches |
| `git branch <name>` | Tạo branch |
| `git checkout <name>` | Chuyển branch |
| `git checkout -b <name>` | Tạo + chuyển branch |
| `git switch <name>` | Chuyển branch (mới) |
| `git switch -c <name>` | Tạo + chuyển (mới) |
| `git merge <branch>` | Merge branch vào hiện tại |
| `git branch -d <name>` | Xóa branch (đã merge) |
| `git branch -D <name>` | Xóa branch (force) |

## Xem lịch sử
| Command | Action |
|---------|--------|
| `git log` | Xem log |
| `git log --oneline` | Log ngắn gọn |
| `git log --graph --oneline` | Log dạng cây |
| `git diff` | Xem thay đổi chưa stage |
| `git diff --staged` | Xem thay đổi đã stage |
| `git show <commit>` | Xem chi tiết commit |
| `git blame <file>` | Ai sửa dòng nào |

## Undo
| Command | Action |
|---------|--------|
| `git restore <file>` | Bỏ thay đổi chưa stage |
| `git restore --staged <file>` | Unstage file |
| `git commit --amend` | Sửa commit cuối |
| `git reset HEAD~1` | Undo commit cuối (giữ changes) |
| `git reset --hard HEAD~1` | Undo commit cuối (xóa changes) |
| `git revert <commit>` | Tạo commit đảo ngược |

## Stash
| Command | Action |
|---------|--------|
| `git stash` | Cất thay đổi tạm |
| `git stash pop` | Lấy lại thay đổi |
| `git stash list` | Xem danh sách stash |
| `git stash drop` | Xóa stash |

## Rebase
| Command | Action |
|---------|--------|
| `git rebase <branch>` | Rebase lên branch |
| `git rebase --continue` | Tiếp tục sau fix conflict |
| `git rebase --abort` | Hủy rebase |

## Remote
| Command | Action |
|---------|--------|
| `git remote -v` | Xem remotes |
| `git push -u origin <branch>` | Push branch mới lên remote |
| `git push origin --delete <branch>` | Xóa branch remote |

## GitHub CLI (gh)
| Command | Action |
|---------|--------|
| `gh repo create <name>` | Tạo repo |
| `gh pr create` | Tạo pull request |
| `gh pr list` | Xem PRs |
| `gh pr checkout <number>` | Checkout PR |
| `gh issue list` | Xem issues |
| `gh repo clone <owner/repo>` | Clone repo |

## Tips
- `git add -p` — stage từng phần (interactive)
- `git log --all --graph --oneline` — xem toàn bộ history dạng cây
- `git cherry-pick <commit>` — copy 1 commit sang branch hiện tại
- `git reflog` — xem mọi thao tác đã làm (cứu khi lỡ tay)
