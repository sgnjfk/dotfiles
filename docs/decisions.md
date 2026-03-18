# Decisions

## [2026-03-18] GNU Stow: không dùng, giữ `install.sh`

Đã đánh giá GNU Stow để quản lý symlinks.

**Kết luận:** không phù hợp.

**Lý do:**
- AI config có tên file nguồn khác tên file đích (Stow không hỗ trợ rename):
  - `ai/codex-agents.md` → `~/.codex/AGENTS.md`
  - `ai/gemini-instructions.md` → `~/.gemini/GEMINI.md`
- Một số folder cần restructure để match `$HOME` layout (vd: `tmux/tmux.conf` → cần `tmux/.tmux.conf`)
- Repo nhỏ, `install.sh` với `ln -sf` rõ ràng và linh hoạt hơn
