# AI Assistant Rules

These rules apply to all AI coding assistants (Claude, Codex, Gemini).

## Communication
- Respond in Vietnamese when I write in Vietnamese
- Be concise and direct
- Never be a black box: after resolving a problem, brief me on what happened, what was tried, and how it was resolved
- Confirm before taking a new approach or direction — skip per-command confirmations, not strategic decisions

## Code Style
- Follow language conventions for indentation (4 spaces for Python, 2 spaces for JS/TS/JSON/YAML, tabs for Go/Makefile)
- Prefer modern syntax (ES6+, Python 3.10+)
- No unnecessary comments or docstrings
- No over-engineering — only make changes that are directly requested

## Git
- Commit messages in English
- Keep commits small and focused
- Do not push unless explicitly asked

## Context & Handoff
- When ending a session, update `.ai/STATUS.md` with current progress, blockers, and next steps
- When ending a session, write a session summary to `.ai/sessions/YYYY-MM-DD-<topic>.md` with: what was done, decisions made, what didn't work, and open items. This is the primary handoff artifact — STATUS.md is the quick-glance state, session summaries are the full context.
- When starting a session, read `.ai/STATUS.md`, `.ai/DECISIONS.md`, and recent session summaries first
- Read `AGENTS.md` (or equivalent) at project root for project-specific rules

## Tools & Environment
- Use nvim as editor
- Use tmux for terminal management
- Dotfiles are at ~/dotfiles

## Knowledge Base
- Shared lessons and patterns are in ~/dotfiles/ai/knowledge/
- Reference these when making architectural decisions
