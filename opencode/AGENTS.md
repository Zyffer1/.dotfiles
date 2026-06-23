# opencode Agents — Specs & Plan

## Purpose

This file documents the agent architecture and setup plan for managing this
dotfiles repo with opencode. Agents automatically use subagents without the
user needing to ask.

## Stow integration

The `opencode/` directory is a stow package:

```
opencode/
├── .config/
│   └── opencode/
│       ├── opencode.jsonc
│       ├── .gitignore
│       └── agents/
│           ├── setup.md       ← primary coordinator (default)
│           ├── plan.md        ← primary planning partner
│           ├── build.md       ← subagent implementer
│           ├── cleanup.md     ← subagent housekeeping
│           ├── driver.md      ← action-oriented proposer
│           ├── idea-maker.md  ← creative brainstorming
│           ├── paranoid.md    ← security reviewer
│           ├── researcher.md  ← research & documentation
│           ├── tester.md      ← project reviewer (no coding)
│           └── verifier.md    ← confirmation agent
├── .stow-local-ignore
├── AGENTS.md
├── context.md
├── plan.md
└── test_opencode.sh
```

## Agents

### Primary agents

| Agent | Role | Auto-delegates to |
|---|---|---|
| **`setup`** | Coordinator — researches, plans, tests, executes, verifies | All subagents automatically per pipeline |
| **`plan`** | Planning partner — discusses, researches, analyzes, designs | researcher + paranoid + driver automatically |

### Subagents

| Agent | Role |
|---|---|
| **`build`** | Efficient implementation of approved plans |
| **`explore`** | Built-in — audits current state |
| **`researcher`** | Reads files, searches web, documents findings |
| **`driver`** | Proposes concrete, efficient solutions |
| **`paranoid`** | Security & risk review |
| **`idea-maker`** | Creative brainstorming |
| **`tester`** | Project feedback — reviews, does NOT code |
| **`verifier`** | Plan critique (pre) + verification checklist (post) |
| **`cleanup`** | Housekeeping — dead configs, orphaned symlinks, empty dirs |

## Automated workflow

**setup** automatically runs this on every task:

```
1. RESEARCH  ──► explore + researcher + driver + paranoid + idea-maker (in parallel)
2. REVIEW    ──► verifier critiques plan → iterate if needed
3. TEST      ──► tester reviews plan & project
4. EXECUTE   ──► setup/build enacts + cleanup removes dead weight
5. VERIFY    ──► verifier runs checklist → "Done ✓"
```

**plan** automatically runs this on discussion:

```
1. RESEARCH  ──► researcher (reads/searches)
2. ANALYZE   ──► paranoid (security review)
3. DESIGN    ──► driver (concrete steps)
4. HANDOFF   ──► "Ready. Switch to setup."
```

**Simple requests** skip the pipeline — setup uses 1-2 relevant agents directly.

## Scope rule

Every agent (setup, build, cleanup) must **only edit files inside its current package directory**. When working in `opencode/`, edits are confined to:
- Files inside `opencode/`
- The repo-root `.gitignore` — only for opencode-related entries
- The `.stow-local-ignore` — already inside the package

Never edit files in other packages (`nvim/`, `zsh/`, `tmux/`, `i3/`, etc.).

## Restart

After modifying `opencode.jsonc` or any agent file, quit and restart opencode.
