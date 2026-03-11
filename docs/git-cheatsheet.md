# Git

## Cơ bản
`git s` Xem status
`git add <file>` Stage 1 file
`git add .` Stage tất cả
`git cm "msg"` Commit với message
`git push` Push lên remote
`git pull` Pull từ remote
`git fetch` Fetch từ remote

## Branch
`git br` Xem danh sách branch
`git br <name>` Tạo branch mới
`git co <name>` Chuyển branch
`git co -b <name>` Tạo và chuyển branch
`git merge <br>` Merge branch vào hiện tại
`git br -d <name>` Xóa branch

## Lịch sử
`git lg` Xem log dạng cây
`git last` Xem commit cuối cùng
`git diff` Xem thay đổi chưa stage
`git diff --staged` Xem thay đổi đã stage
`git show <commit>` Xem chi tiết 1 commit
`git blame <file>` Xem ai sửa từng dòng

## Undo
`git restore <file>` Bỏ thay đổi chưa stage
`git restore --staged <f>` Unstage file
`git commit --amend` Sửa commit cuối cùng
`git undo` Undo commit cuối (giữ changes)
`git revert <commit>` Đảo ngược 1 commit

## Stash
`git stash` Cất thay đổi tạm thời
`git stash pop` Lấy lại stash mới nhất
`git stash list` Xem danh sách stash
`git stash drop` Xóa stash mới nhất

## Rebase
`git rebase <br>` Rebase lên branch
`git rebase --continue` Tiếp tục rebase
`git rebase --abort` Hủy rebase

## GitHub CLI
`gh repo create` Tạo repo mới trên GitHub
`gh pr create` Tạo pull request
`gh pr list` Xem danh sách PR
`gh pr checkout <N>` Checkout 1 PR
`gh issue list` Xem danh sách issues

## Tips
`git add -p` Stage từng phần (interactive)
`git cherry-pick <c>` Copy 1 commit sang branch khác
`git reflog` Xem lịch sử mọi thao tác (cứu khi lỡ tay)
