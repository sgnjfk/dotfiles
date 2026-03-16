# AI-Assisted Development System

A unified system for working with multiple AI coding assistants across machines.

## Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                        GLOBAL LAYER                             │
│                    ~/dotfiles/ai/                                │
│                                                                 │
│  ┌─────────────┐  ┌──────────────┐  ┌────────────────────────┐ │
│  │  RULES.md   │  │  knowledge/  │  │  Tool-specific configs  │ │
│  │  (shared    │  │  lessons.md  │  │  codex-agents.md       │ │
│  │   rules)    │  │  patterns.md │  │  gemini-instructions.md│ │
│  │             │  │  anti-pat..  │  │  aider-conventions.md  │ │
│  └──────┬──────┘  └──────────────┘  └───────────┬────────────┘ │
│         │                                        │              │
│         │              symlinks                  │              │
└─────────┼────────────────────────────────────────┼──────────────┘
          │                                        │
          ▼                                        ▼
┌──────────────┐ ┌──────────────┐ ┌──────────────┐ ┌─────────────┐
│ ~/.claude/   │ │ ~/.codex/    │ │ ~/.gemini/   │ │ ~/.aider    │
│ CLAUDE.md    │ │ AGENTS.md ──►│ │ GEMINI.md ──►│ │ .conf.yml   │
│ (@import     │ │ (symlink)    │ │ (symlink)    │ │ (read:      │
│  RULES.md)   │ │              │ │              │ │  conventions)│
└──────────────┘ └──────────────┘ └──────────────┘ └─────────────┘
```

## Project Layer

When you run `ai-init <project>`, this structure is created:

```
project/
├── AGENTS.md              ← Single source of truth (edit this)
├── CLAUDE.md              → symlink to AGENTS.md
├── GEMINI.md              → symlink to AGENTS.md
├── .aider.conf.yml        ← reads AGENTS.md
└── .ai/
    ├── STATUS.md          ← Current progress & handoff notes
    ├── DECISIONS.md       ← Architecture decisions & rationale
    └── GLOSSARY.md        ← Domain-specific terminology
```

**One file to rule them all**: edit `AGENTS.md`, every AI reads it.

## How Each Tool Reads Instructions

```
                        ┌─────────────┐
                        │  AGENTS.md  │  ← You edit this
                        │  (project)  │
                        └──────┬──────┘
                               │
              ┌────────────────┼────────────────┐
              │                │                │
         symlink          symlink          .aider.conf.yml
              │                │            read: AGENTS.md
              ▼                ▼                │
        ┌──────────┐    ┌──────────┐    ┌──────┴─────┐
        │CLAUDE.md │    │GEMINI.md │    │   Aider    │
        └──────────┘    └──────────┘    └────────────┘
              │                │
              ▼                ▼
        Claude Code      Gemini CLI
                               │
                          also reads
                       AGENTS.md natively
                               │
                               ▼
                          Codex CLI
                    (fallback: AGENTS.md)
```

### Cross-tool config

| Tool       | Global config                  | Project config          | How it reads AGENTS.md      |
|------------|-------------------------------|-------------------------|-----------------------------|
| Claude     | `~/.claude/CLAUDE.md`          | `CLAUDE.md` (symlink)   | Via symlink                 |
| Codex      | `~/.codex/AGENTS.md`           | `AGENTS.md`             | Native + fallback config    |
| Gemini     | `~/.gemini/GEMINI.md`          | `GEMINI.md` (symlink)   | Via symlink + context config|
| Aider      | `~/.aider.conf.yml`            | `.aider.conf.yml`       | Via `read:` config          |

## AI Handoff Protocol

When switching between AI assistants mid-task:

```
  AI Session 1                          AI Session 2
  ┌──────────┐                         ┌──────────┐
  │ Working  │                         │ Reads    │
  │ on task  │──► Update STATUS.md ──► │ STATUS.md│
  │          │    before ending         │ to get   │
  │          │                         │ context  │
  └──────────┘                         └──────────┘

  STATUS.md contains:
  • What's in progress
  • Recent changes
  • Next steps
  • Blockers
  • Notes for next AI
```

**Before ending a session**, tell the AI:
> "Update .ai/STATUS.md with current progress"

**When starting a new session**, the AI reads:
1. `AGENTS.md` — project rules & architecture
2. `.ai/STATUS.md` — what's happening now
3. `.ai/DECISIONS.md` — why things are the way they are

## Knowledge Base

Shared learnings across all projects:

```
~/dotfiles/ai/knowledge/
├── lessons.md         Mistakes made & lessons learned
├── patterns.md        Preferred patterns & approaches
└── anti-patterns.md   Things to avoid
```

Update these over time. All AI tools can reference them via global instructions.

## Setup

### New machine
```bash
git clone <dotfiles-repo> ~/dotfiles
~/dotfiles/ai/setup.sh
```

### New project
```bash
ai-init ./my-project
# Then edit AGENTS.md with project details
```

### Sync between machines
```bash
cd ~/dotfiles && git pull   # on each machine
```

> **Note**: AI auto-memory (Claude's `~/.claude/projects/` memory, Codex memories, etc.)
> is machine-local and does NOT sync. Only the rules and knowledge base sync via git.

## File Reference

| File | Purpose | Sync? |
|------|---------|-------|
| `ai/RULES.md` | Shared rules for all AI tools | ✅ Git |
| `ai/knowledge/*.md` | Lessons, patterns, anti-patterns | ✅ Git |
| `ai/templates/*.md` | Templates for `ai-init` | ✅ Git |
| `ai/codex-agents.md` | Codex global instructions | ✅ Git |
| `ai/gemini-instructions.md` | Gemini global instructions | ✅ Git |
| `ai/aider-conventions.md` | Aider global conventions | ✅ Git |
| `ai/setup.sh` | Setup script for new machines | ✅ Git |
| `ai/ai-init.sh` | Init AI context in a project | ✅ Git |
| `claude/CLAUDE.md` | Claude global instructions | ✅ Git |
| `~/.claude/projects/*/memory/` | Claude auto-memory | ❌ Local |
| `~/.codex/memories/` | Codex auto-memory | ❌ Local |
