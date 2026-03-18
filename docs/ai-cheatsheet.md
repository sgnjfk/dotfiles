# AI System Cheatsheet

## Quick Commands

| Command | Description |
|---------|-------------|
| `ai-init <path>` | Init AI context in a project |
| `ai-docs` | View full system docs |
| `cs ai` | This cheatsheet |

## AI Tools

| Tool | Start | Global config |
|------|-------|---------------|
| Claude | `claude` | `~/.claude/CLAUDE.md` |
| Codex | `codex` | `~/.codex/AGENTS.md` |
| Gemini | `gemini` | `~/.gemini/GEMINI.md` |
| Aider | `aider` | `~/.aider.conf.yml` |

## Quick Query (non-interactive)

| Command | Tool |
|---------|------|
| `ask <question>` | Claude |
| `askg <question>` | Gemini |
| `askx <command>` | Codex |

## Project Structure (after `ai-init`)

```
project/
├── AGENTS.md          ← Edit this (all tools read it)
├── CLAUDE.md          → symlink
├── GEMINI.md          → symlink
├── .aider.conf.yml    ← reads AGENTS.md
└── .ai/
    ├── STATUS.md      ← Handoff notes
    ├── DECISIONS.md   ← Architecture decisions
    └── GLOSSARY.md    ← Domain terms
```

## Handoff Between AIs

**End session:**
> "Update .ai/STATUS.md with current progress"

**Start session:**
> AI auto-reads AGENTS.md + .ai/STATUS.md

## Global Files

```
~/dotfiles/ai/
├── RULES.md               Shared rules (all tools)
├── knowledge/
│   ├── lessons.md         Mistakes & learnings
│   ├── patterns.md        Preferred approaches
│   └── anti-patterns.md   Things to avoid
├── templates/             Project templates
├── setup.sh               New machine setup
└── ai-init.sh             New project init
```

## New Machine Setup

```bash
git clone <dotfiles> ~/dotfiles
~/dotfiles/ai/setup.sh
```
