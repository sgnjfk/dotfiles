# Git

## Cơ bản
`git s` Status
`git add <file>` Stage file
`git add .` Stage all
`git cm "msg"` Commit
`git push` Push
`git pull` Pull
`git fetch` Fetch

## Branch
`git br` Xem branches
`git br <name>` Tạo branch
`git co <name>` Chuyển
`git co -b <name>` Tạo+chuyển
`git merge <br>` Merge
`git br -d <name>` Xóa

## Lịch sử
`git lg` Log cây
`git last` Commit cuối
`git diff` Xem thay đổi
`git diff --staged` Đã stage
`git show <commit>` Chi tiết
`git blame <file>` Ai sửa

## Undo
`git restore <file>` Bỏ thay đổi
`git restore --staged <f>` Unstage
`git commit --amend` Sửa commit cuối
`git undo` Undo commit cuối
`git revert <commit>` Đảo ngược

## Stash
`git stash` Cất tạm
`git stash pop` Lấy lại
`git stash list` Danh sách
`git stash drop` Xóa

## Rebase
`git rebase <br>` Rebase
`git rebase --continue` Tiếp
`git rebase --abort` Hủy

## GitHub CLI
`gh repo create` Tạo repo
`gh pr create` Tạo PR
`gh pr list` Xem PRs
`gh pr checkout <N>` Checkout PR
`gh issue list` Xem issues

## Tips
`git add -p` Stage từng phần
`git cherry-pick <c>` Copy commit
`git reflog` Cứu khi lỡ tay
