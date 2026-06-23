# OpenCode Config — Documentation

> Manages the dotfiles repository at `~/me/.dotfiles/` using GNU Stow.
> A team of specialist AI agents that collaborate to maintain and improve the setup.

---

## Table of Contents

- [Architecture](#architecture)
- [Agents](#agents)
- [MCP Servers](#mcp-servers)
- [Skills](#skills)
- [Workflows](#workflows)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Testing](#testing)
- [Theme](#theme)
- [Repository Structure](#repository-structure)

---

## Architecture

The opencode config provides two primary agents and eight subagents:

```
┌─────────────────────────────────────────────────┐
│                   opencode                        │
├─────────────────────────────────────────────────┤
│  Primary Agents      Subagents                   │
│  ┌─────────┐   ┌──────────┐  ┌─────────┐        │
│  │  setup  │   │ build    │  │ cleanup │        │
│  │ (exec)  │   │ driver   │  │ tester  │        │
│  ├─────────┤   │ paranoid │  │ verifier│        │
│  │  plan   │   │ researcher│ │ ideamkr │        │
│  │ (design)│   └──────────┘  └─────────┘        │
│  └─────────┘                                      │
└─────────────────────────────────────────────────┘
```

**Two concurrent sessions** can run in separate tmux panes:

| Pane | Command | Agent | Role |
|------|---------|-------|------|
| Left  | `opencode` | `setup` (default) | Execute plans, make changes, verify |
| Right | `opencode --agent plan` | `plan` | Research, design, discuss future work |

**Handoff:** Plan writes to `plan.md` → Setup reads and executes.

---

## Agents

### Primary Agents

| Agent | Mode | Role | Permissions | When to use |
|-------|------|------|-------------|-------------|
| `setup` | Primary | Coordinator — researches, plans, tests, executes, verifies | Full (read, edit, bash, task) | Default — any task that needs doing |
| `plan` | Primary | Planning partner — researches, analyzes, designs | Read-only + bash (ask) | "Let's plan" / "I want to discuss" |

### Subagents

| Agent | Role | Permissions |
|-------|------|-------------|
| `explore` | Built-in — fast codebase explorer, audits current state | Read-only |
| `build` | Efficient implementation of approved plans | Full |
| `researcher` | Reads files, searches web, documents in context.md/plan.md | Read + edit + bash + web |
| `driver` | Proposes efficient, concrete solutions | Read + bash |
| `paranoid` | Security & risk review — unsafe patterns, secret leakage, edge cases | Read-only |
| `idea-maker` | Creative brainstorming — novel tools, workflows, approaches | Read + edit + bash + web |
| `tester` | Project feedback — reviews current state, does NOT code | Read + edit + bash |
| `verifier` | Plan critique (pre-execution) + verification checklist (post-execution) | Read + bash |
| `cleanup` | Housekeeping — dead configs, orphaned symlinks, empty dirs | Read + edit + bash |

---

## MCP Servers

| Server | Type | Purpose | Status | Notes |
|--------|------|---------|--------|-------|
| `browser` | Local (`@playwright/mcp`) | Web browsing, page interaction | ✅ Enabled | Full browser automation |
| `searxng` | Local (`mcp-searxng`) | Privacy-focused web search | ✅ Enabled | Self-hosted at `localhost:8080` |
| `github` | Local (`@modelcontextprotocol/server-github`) | GitHub API — PRs, issues, repos | ✅ Enabled | Requires `GITHUB_TOKEN` |

---

## Skills

| Skill | Purpose |
|-------|---------|
| `stow` | GNU Stow package management |
| `shell-config` | Shell config writing (zsh/bash) |
| `system-audit` | System state auditing |
| `tmux` | tmux configuration |
| `git-workflow` | Git operations, git.sh safety |
| `nvim-config` | Neovim config guide |
| `idea-generation` | Brainstorming framework |
| `verifier-checklist` | Verification checklist |
| `security-audit` | Security audit checklist |

---

## Workflows

### Standard Pipeline (setup)

When a request comes in, `setup` automatically runs:

1. **Research** — explore + researcher + driver + paranoid + idea-maker (in parallel)
2. **Review** — verifier critiques plan → iterate if needed
3. **Test** — tester reviews plan & project state
4. **Execute** — build enacts changes + cleanup removes dead weight
5. **Verify** — verifier runs checklist → "Done ✓"

Simple requests skip the pipeline and use 1-2 relevant agents directly.

### Planning Workflow (plan)

When you want to discuss ideas, `plan` automatically runs:

1. **Research** — researcher + explore (in parallel)
2. **Analyze** — paranoid reviews proposals
3. **Design** — driver proposes concrete steps
4. **Write** — researcher writes the approved plan to `plan.md`
5. **Hand off** — "Plan written. Switch to setup session."

### Parallel Sessions

Two opencode sessions can run concurrently in separate tmux panes:

```
┌─────────────────────┐  ┌─────────────────────┐
│  Pane 1: setup       │  │  Pane 2: plan        │
│  $ opencode          │  │  $ opencode --agent  │
│                      │  │         plan         │
│  Executes tasks      │  │  Researches, designs │
│  Reads plan.md       │  │  Writes to plan.md   │
│  Marks ✅ / 🚧       │  │  Hands off to setup  │
└─────────────────────┘  └─────────────────────┘
         ▲                        │
         │    reads plan.md       │ writes
         └────────────────────────┘
```

### For Simple Requests

Quick fix? Do it or send to `build`.
Quick question? Answer it.
Need research? Send to `researcher`.
Need a review? Send to `tester` or `verifier`.
Need cleanup? Send to `cleanup`.

---

## Configuration

Key settings in `opencode.jsonc`:

| Setting | Value | Notes |
|---------|-------|-------|
| `default_agent` | `setup` | Starting agent for `opencode` |
| `lsp` | `true` | LSP enabled for code understanding |
| MCP servers | 3 | browser, searxng, github |

All agent permissions are defined per-agent in `opencode.jsonc` and their respective `.md` files.

---

## Deployment

```bash
./stow.sh              # deploy everything
stow --no -t ~ <pkg>   # dry-run
stow -D -t ~ <pkg>     # un-stow
stow --restow -t ~ <pkg>  # fix broken symlinks
```

Packages: `i3`, `zsh`, `nvim`, `tmux`, `wezterm`, `bat`, `opencode`, `bash`, `picom`, `vim`

---

## Testing

### opencode test suite (19 tests, 6 categories)
```bash
cd ~/me/.dotfiles/opencode && ./test_opencode.sh        # full suite
./test_opencode.sh <category>                            # run one category
./test_opencode.sh --list                                # list categories
```

Categories: `jsonc`, `agents`, `stow`, `scripts`, `searxng`, `skills`

### nvim test suite (9 checks)
```bash
cd ~/me/.dotfiles/nvim && ./test_nvim_config.sh
```

---

## Theme — Rose-pine-moon

Every visual tool uses the rose-pine-moon color scheme:

| Tool | How |
|------|-----|
| **nvim** | `rose-pine` plugin, `variant = "moon"` |
| **wezterm** | `neapsix/wezterm` plugin, `.moon` variant |
| **bat** | `--theme="rose-pine-moon"` |
| **i3bar** | Dark-toned colors (Catppuccin-ish) |

---

## Repository Structure

Top-level stow packages under `~/me/.dotfiles/`:

| Package | What it configures |
|---------|-------------------|
| `zsh` | Zsh shell — `.zshrc`, plugins, aliases, prompt |
| `bash` | Bash shell — `.bashrc` (fallback) |
| `nvim` | Neovim editor — `init.lua`, lazy.nvim, LSP, keymaps |
| `tmux` | Tmux terminal multiplexer — `tmux.conf`, TPM plugins |
| `wezterm` | WezTerm terminal emulator |
| `bat` | Bat file viewer — theme, options |
| `i3` | i3 window manager + i3status bar |
| `picom` | Picom compositor — blur, opacity |
| `opencode` | OpenCode — agents, MCP servers, skills |
| `vim` | Legacy vim config (mostly stale) |

Non-stowed: `scripts/` (in PATH), `default.conf` (keyd, symlinked to `/etc/keyd/`).

### Key Packages Detail

**nvim** — most complex, fully keyboard-driven
- Entry: `init.lua` → `require("Zyffer")` — modular lazy.nvim config
- 31 plugins, LSP via `vim.lsp.enable` (Neovim 0.11+), conform for formatting
- Rules: No AI/Copilot, no mouse, no bloated UI (no which-key, no noice, no notify)
- Tested: `test_nvim_config.sh` validates boot, LSP, keymaps, plugins, filetypes

**zsh** — primary shell
- Entry: `.zshrc` → sources `exstraconf/*.zsh` for modules
- Plugins: zsh-autosuggestions, zsh-syntax-highlighting, zoxide, fzf
- Secrets: `secret.zsh` is gitignored for personal tokens/envars

**tmux** — terminal multiplexer
- Config: `tmux.conf` with TPM, vim-tmux-navigator, autoreload
- Sessionizer: `M-f` → `~/me/.dotfiles/scripts/tmux-sessionizer`

**keyd** — keyboard remapping daemon
- `default.conf` symlinked to `/etc/keyd/default.conf` outside stow

---

> **Non-goals:** No AI plugins/Copilot, no SaaS dependencies, no mouse-dependent workflows, no bloated plugin ecosystems.
