# AGENTS.md — Complete Repository Guide for AI Agents

This is the **single source of truth** for this dotfiles repository. Any AI agent
working here should read this file first. It merges the repository guide with full
context about every package, script, and convention.

> **Last updated:** 2026-06-27
> **Repo path:** `~/me/personal/.dotfiles/` (aliased as `~/me/.dotfiles/`)

---

## Table of Contents

1. [Repository Overview](#1-repository-overview)
2. [Directory Layout](#2-directory-layout)
3. [Stow System](#3-stow-system)
4. [Per-Package Deep Dives](#4-per-package-deep-dives)
   - [nvim/ — Neovim](#41-nvim---neovim)
   - [zsh/ — Zsh Shell](#42-zsh---zsh-shell)
   - [tmux/ — Terminal Multiplexer](#43-tmux---terminal-multiplexer)
   - [wezterm/ — Terminal Emulator](#44-wezterm---terminal-emulator)
   - [i3/ — Window Manager](#45-i3---window-manager)
   - [bat/ — Cat Clone](#46-bat---cat-clone)
   - [picom/ — Compositor](#47-picom---compositor)
   - [opencode/ — AI Agent Config](#48-opencode---ai-agent-config)
   - [bash/ — Fallback Shell](#49-bash---fallback-shell)
   - [vim/ — Legacy Config](#410-vim---legacy-config)
5. [Scripts Reference](#5-scripts-reference)
6. [Conventions & Philosophy](#6-conventions--philosophy)
7. [Danger Zones](#7-danger-zones)
8. [OpenCode Agent System](#8-opencode-agent-system)
9. [Git & Remotes](#9-git--remotes)
10. [Common Operations Cheatsheet](#10-common-operations-cheatsheet)

---

## 1. Repository Overview

This is a personal dotfiles repository managed with **GNU Stow**. Every top-level
directory (except `scripts/` and `.git/`) is a Stow package that gets symlinked
into `$HOME`. The repo has **two git remotes**: GitHub (`origin`) and GitLab (`gitlab`).

### Philosophy

- **Minimal** — only what's needed, nothing extraneous.
- **Keyboard-driven** — no mouse in Neovim, vi-mode in shell.
- **Rose-pine-moon theme** — every visual tool uses this dark purple theme.
- **No AI/Copilot** in the editor — the AI is in OpenCode, not in Neovim.
- **No SaaS dependencies** — everything is local or vendored.

### Key Facts

| Fact | Value |
|---|---|
| Shell | Zsh (primary), Bash (fallback) |
| Editor | Neovim with lazy.nvim |
| Terminal | WezTerm (Wayland-disabled) |
| WM | i3 (X11 only) |
| Compositor | Picom (GLX, dual_kawase blur) |
| Tmux | with TPM plugins |
| Bat theme | rose-pine-moon |
| Keyd | CapsLock → Backspace, Backspace → Delete |
| Stow packages | 10 (bash, bat, i3, nvim, opencode, picom, tmux, vim, wezterm, zsh) |
| Scripts (unstowed) | 3 (tmux-sessionizer, selfhost, reshade-linux.sh) |
| Git remotes | 2 (github, gitlab) |
| Commit style | Always "hello" (single message for all changes) |

---

## 2. Directory Layout

### Top-level items

```
~/me/.dotfiles/
  AGENTS.md         <- THIS FILE — full AI guide
  README.md         <- Human-friendly overview
  .gitignore        <- Git ignore rules
  stow.sh           <- Deploy all packages via Stow
  git.sh            <- ⚠️ DANGEROUS: force-push to both remotes
  default.conf      <- Keyd config (symlinked to /etc/keyd/)
  install.log       <- Spicetify install log (tracked noise)
  bash/             <- Stow package
  bat/              <- Stow package
  i3/               <- Stow package
  nvim/             <- Stow package (most complex)
  opencode/         <- Stow package
  picom/            <- Stow package
  scripts/          <- NOT stowed; added to PATH via zsh
  tmux/             <- Stow package
  vim/              <- Stow package (legacy/stale)
  wezterm/          <- Stow package
  zsh/              <- Stow package
```

### Stow package structure pattern

Every stow package mirrors the `$HOME` directory structure. For example,
`nvim/.config/nvim/init.lua` gets symlinked to `~/.config/nvim/init.lua`.
Stow does `ln -s` from the package's files into the target directory (`~`).

### Files NOT stowed (repo root only)

- `AGENTS.md`, `README.md`, `.gitignore`
- `stow.sh`, `git.sh`
- `default.conf`, `install.log`
- `.git/` (git metadata)

---

## 3. Stow System

### How Stow Works

GNU Stow creates symlinks from the package directory into the target directory.
For a package like `nvim/`, the file `nvim/.config/nvim/init.lua` becomes
`~/.config/nvim/init.lua → ../me/.dotfiles/nvim/.config/nvim/init.lua`.

### Deploy Commands

```bash
./stow.sh                          # deploy everything (run from repo root)
stow -t ~ <package>                # deploy a single package
stow -D -t ~ <package>             # un-stow a package
stow --restow -t ~ <package>       # re-stow (un-stow then stow)
stow --no -t ~ <package>           # dry-run before deploying
```

### stow.sh Behavior

The `stow.sh` script at repo root does:
1. `stow -t ~ i3 zsh nvim tmux wezterm bat opencode bash picom vim`
2. Symlinks `default.conf` to `/etc/keyd/default.conf` (with `sudo`, only if not already linked)

It does **not** do root-level stow (`sudo stow -t /root/`).
If you need root configs, you'd need to add that manually.

### Dry-Run All Packages

```bash
for pkg in i3 zsh nvim tmux wezterm bat opencode bash picom vim; do
  echo "=== $pkg ==="
  stow --no -v -t ~ "$pkg" 2>&1 || true
done
```

### Known Stow Characteristics

- Stow will **refuse** if a file already exists at the target path (not a symlink).
- To overwrite, manually remove the file first, then re-stow.
- Each package is independent; they don't conflict with each other.

---

## 4. Per-Package Deep Dives

### 4.1 nvim/ — Neovim

**Most complex package in the repo.**

#### File Tree

```
nvim/.config/nvim/
  init.lua                          -> require("Zyffer")
  lazy-lock.json                    -> plugin lockfile (committed)
  lua/Zyffer/
    init.lua                        -> loads keymaps, set, lazy_init, autocmds, ftdetect
    set.lua                         -> vim.opt options
    keymaps.lua                     -> keyboard mappings
    autocmds.lua                    -> autocommands
    ftdetect.lua                    -> filetype detection
    lazy_init.lua                   -> lazy.nvim bootstrap & plugin loading
    lspenable.lua                   -> LSP server list, Mason, server configs
    plugins/
      23 plugin config files        -> one file per plugin
```

#### Architecture

- **Entrypoint:** `init.lua` → `require("Zyffer")` → loads submodules
- **Module system:** All config lives under `lua/Zyffer/` (avoiding global namespace pollution)
- **Plugin manager:** lazy.nvim (bootstraps from GitHub if not installed)
- **LSP:** Uses Neovim 0.11+ `vim.lsp.enable` API (NOT `lspconfig.manager`)
  - Servers lazy-loaded by filetype via `ft` triggers
  - Server list in `lspenable.lua`
  - Mason auto-installs servers on non-NixOS
  - On NixOS, only enables servers whose binaries are already on `$PATH`

#### Key Principles

- **Keyboard only:** `vim.opt.mouse = ""` — no mouse at all
- **No AI/Copilot** in the editor
- **No SaaS** integrations
- **No fancy UI plugins:** no noice.nvim, no notify.nvim, no which-key.nvim, no flash.nvim
- **Minimal plugin set** — 23 plugins, each focused

#### LSP Servers (14 total)

bashls, clangd, cssls, gopls, html, jsonls, lua_ls, marksman, nixd, pyright,
rust_analyzer, taplo, ts_ls, yamlls

#### Mason Tools (15 total)

alejandra, goimports, jq, markdownlint, nixfmt, prettier, prettierd, ruff,
selene, shfmt, statix, stylua, taplo, yamlfmt, yamllint

#### Plugin Inventory (23 plugins)

| Plugin File | Plugin | Purpose |
|---|---|---|
| `actions-preview.lua` | aznhe21/actions-preview.nvim | Preview code actions |
| `autocmp.lua` | hrsh7th/nvim-cmp | Autocompletion engine |
| `autopairs.lua` | windwp/nvim-autopairs | Auto-close brackets/quotes |
| `colorizer.lua` | norcalli/nvim-colorizer.lua | Color hex preview |
| `colors.lua` | rose-pine/neovim | rose-pine-moon theme |
| `comment.lua` | numtostr/Comment.nvim | Toggle comments |
| `conform.lua` | stevearc/conform.nvim | Format-on-save |
| `fidget.lua` | j-hui/fidget.nvim | LSP progress spinner |
| `gitsigns.lua` | lewis6991/gitsigns.nvim | Git signs in gutter |
| `harpoon.lua` | ThePrimeagen/harpoon | Quick file marks |
| `indent-blankline.lua` | lukas-reineke/indent-blankline.nvim | Indent guides |
| `lsp_config.lua` | (built-in) | `vim.lsp.config` setup |
| `mason.lua` | williamboman/mason.nvim | LSP/tool installer |
| `null_ls.lua` | nvimtools/none-ls.nvim | Diagnostics only (not formatting) |
| `oil.lua` | stevearc/oil.nvim | File explorer |
| `oil-lsp.lua` | (companion) | LSP integration for oil |
| `surround.lua` | kylechui/nvim-surround | Surround editing |
| `tabout.lua` | abecodes/tabout.nvim | Tab out of brackets |
| `telescope.lua` | nvim-telescope/telescope.nvim | Fuzzy finder |
| `treesitter.lua` | nvim-treesitter/nvim-treesitter | Syntax parsing |
| `trouble.lua` | folke/trouble.nvim | Diagnostics list |
| `undotree.lua` | mbbill/undotree | Undo history visualizer |
| `vim-tmux-nav.lua` | christoomey/vim-tmux-navigator | Seamless pane navigation |

#### Key Mappings

| Mapping | Action |
|---|---|
| `<M-h/j/k/l>` | Navigate windows |
| `<leader> (space)` | Leader key |
| `n/N/*/#` | Search centered (`zzzv`) |
| `<C-d>/<C-u>` | Page up/down centered |
| `Y` | Yank to end of line |
| `]d/[d` | Next/prev diagnostic |
| `]q/[q` | Next/prev quickfix |
| `<C-q>` in terminal | Exit terminal mode |
| `<leader>sp` | Toggle spell check |
| Arrow keys | Disabled (all modes) |

#### Important Note

There is **no `test_nvim_config.sh`** anymore. It was deleted. To verify the config,
you would need to manually start Neovim and run `:checkhealth`.

---

### 4.2 zsh/ — Zsh Shell

**Primary shell. Sources everything from `exstraconf/` directory.**

#### Entrypoint

```zsh
# ~/.zshrc
for file in ~/.config/zsh/exstraconf/*.zsh; do
  [ -f "$file" ] && source "$file"
done
```

#### Module Files (8 files in `exstraconf/`)

| File | Purpose |
|---|---|
| `aliases.zsh` | `ls -lah --color=auto`, `grep --color=auto`, `fzf` with bat preview, `nvim`, `nixvi` |
| `expots.zsh` | `EDITOR=nvim`, `MANPAGER='nvim +Man!'`, `PATH` additions |
| `eyecandy.zsh` | Prompt with git info |
| `git.zsh` | `git_prompt_info()` function |
| `hist.zsh` | History settings (size, file location, dedup) |
| `menulist.zsh` | Tab completion settings |
| `sourceingplugins.zsh` | Loads zsh-autosuggestions, zsh-syntax-highlighting, zoxide, fzf |
| `vi(mode).zsh` | Vi-mode with cursor shape changes |

#### Plugins (vendored in `~/.config/zsh/plugins/`)

- `git.plugin.zsh` — vendored from oh-my-zsh (14KB)
- `zsh-autosuggestions/` — full vendored plugin directory
- `zsh-syntax-highlighting/` — full vendored plugin directory with highlighters

#### Secrets

`secret.zsh` is **gitignored** (listed in `.gitignore`). If it exists, it's
sourced automatically by the `exstraconf/*.zsh` loop. Place API keys, tokens,
or personal secrets there.

---

### 4.3 tmux/ — Terminal Multiplexer

#### Entrypoint

```
~/.config/tmux/tmux.conf
```

#### Plugins (via TPM)

| Plugin | Purpose |
|---|---|
| tmux-plugins/tpm | Plugin manager itself |
| tmux-plugins/tmux-sensible | Sensible defaults |
| christoomey/vim-tmux-navigator | Seamless vim/tmux navigation |
| b0o/tmux-autoreload | Auto-reload on config change |

#### Key Bindings

| Binding | Action |
|---|---|
| `M-r` | Reload tmux config |
| `M-f` | Open tmux-sessionizer (fzf session picker) |
| `M-1` through `M-0` | Select windows 1-10 |
| `M-h/j/k/l` | Navigate panes (matches Neovim) |

#### Configuration Details

- Status bar at **top**, shows session name and time
- Base index starts at 1 (not 0)
- Simple pane borders (`pane-border-lines simple`)
- Passthrough enabled for OSC 52 clipboard
- TPM installed to `~/.tmux/plugins/` (gitignored)
- Install TPM plugins with `prefix + I` after first deploy

---

### 4.4 wezterm/ — Terminal Emulator

#### Entrypoint

```
~/.config/wezterm/wezterm.lua
```

#### Configuration

| Setting | Value |
|---|---|
| Font | JetBrains Mono, size 22 |
| Window size | 120 × 28 characters |
| Tab bar | Disabled |
| Opacity | 0.0 (fully transparent over picom blur) |
| Frame rate | 165 FPS |
| Front end | WebGPU |
| Wayland | Disabled (uses X11) |
| Theme | rose-pine-moon (fetched via plugin) |
| Font reset | `Ctrl+Shift+R` |

#### Theme Loading

The rose-pine-moon theme is fetched at runtime via the wezterm plugin system:
```lua
local rose_pine = wezterm.plugin.require('https://github.com/neapsix/wezterm').moon
config.colors = rose_pine.colors()
config.window_frame = rose_pine.window_frame()
```

---

### 4.5 i3/ — Window Manager

#### Entrypoint

```
~/.config/i3/config
```

#### Key Bindings

| Binding | Action |
|---|---|
| `$mod (Mod4/Super)` | Modifier key |
| `$mod+Return` | Launch WezTerm |
| `$mod+d` | Rofi application launcher |
| `$mod+Shift+q` | Kill focused window |
| `$mod+Shift+l` | Lock screen (i3lock) |
| `$mod+h/j/k/l` | Focus left/down/up/right |
| `$mod+f` | Toggle fullscreen |
| `$mod+space` | Toggle floating |
| `$mod+1-0` | Switch to workspace 1-10 |
| `$mod+Shift+1-0` | Move window to workspace |
| `$mod+Shift+r` | Restart i3 |
| `$mod+r` | Enter resize mode |
| `$mod+m` | Exit i3 |

#### Autostart

- `dex --autostart` (DE autostart apps)
- `xss-lock` with `i3lock`
- `nm-applet` (network manager)
- `picom` compositor (with path to picom.conf)
- `feh` wallpaper

#### Workspaces

Workspaces 1-9 on `DP-3`, workspace 10 on `HDMI-1`.
All focused on external display (no laptop screen binding).

#### Bar

i3status at bottom, JetBrainsMono Nerd Font, Catppuccin Mocha-ish colors.
Separate i3status config at `~/.config/i3status/config`.

---

### 4.6 bat/ — Cat Clone

#### Config

```
~/.config/bat/config
--theme="rose-pine-moon"
```

#### Theme Files

Bundled `.tmTheme` files in `bat/.config/bat/themes/`:
- `rose-pine-dawn.tmTheme`
- `rose-pine-moon.tmTheme`
- `rose-pine.tmTheme`

---

### 4.7 picom/ — Compositor

#### Config (`picom.conf`)

| Setting | Value |
|---|---|
| Backend | glx |
| Vsync | true |
| Blur method | dual_kawase |
| Blur strength | 6 |
| WezTerm opacity | 80% |

---

### 4.8 opencode/ — AI Agent Configuration

This package configures the **OpenCode** AI coding assistant.
Deployed via stow to `~/.config/opencode/`.

#### Structure

```
opencode/.config/opencode/
  opencode.jsonc              <- Main config (MCP servers, agents)
  .gitignore                  <- Ignores node_modules, package.json, etc.
  agents/                     <- Agent definitions
    setup.md                  <- Primary coordinator agent
    plan.md                   <- Planning agent
    build.md                  <- Implementation agent
    researcher.md             <- Research agent
    driver.md                 <- Solution pro agent
    paranoid.md               <- Security reviewer
    tester.md                 <- Project reviewer
    verifier.md               <- Verification agent
    idea-maker.md             <- Creative brainstorming agent
    cleanup.md                <- Housekeeping agent
  skills/                     <- Skill definitions
    git-workflow/SKILL.md
    idea-generation/SKILL.md
    nvim-config/SKILL.md
    security-audit/SKILL.md
    shell-config/SKILL.md
    stow/SKILL.md
    system-audit/SKILL.md
    tmux/SKILL.md
    verifier-checklist/SKILL.md
  node_modules/               <- npm dependencies (installed, tracked by stow)
  package.json
  package-lock.json
```

#### MCP Servers (in opencode.jsonc)

| Server | Tool | Purpose |
|---|---|---|
| browser | `@playwright/mcp` | Browser automation |
| searxng | `mcp-searxng` | Web search (via local SearXNG at :8080) |
| github | `@modelcontextprotocol/server-github` | GitHub API access |

#### Agent Architecture

The `setup` agent is the primary coordinator. It automatically orchestrates
sub-agents in phases (research → plan → test → execute → verify → cleanup).
The `plan` agent is a separate primary for planning-only sessions.

---

### 4.9 bash/ — Fallback Shell

Minimal `.bashrc`, used when Zsh is unavailable (e.g., recovery mode, cron).

```bash
# Provides:
alias ls='ls -lah --color=auto'
alias grep='grep --color=auto'
alias fzf='fzf -m --preview="bat --color=always {}"'
export EDITOR=nvim
export PATH="$HOME/me/.dotfiles/scripts/:$PATH"
export MANPAGER='nvim +Man!'
```

`clear` also runs `neofetch` (behavior set in bashrc).

---

### 4.10 vim/ — Legacy Config

Mostly stale/unused. Vim is not the primary editor.

```vim
" .vimrc sources three files:
source ~/.vim.Zyffer/set.vim       " Basic options (numbers, 2-space indent, no mouse, scrolloff=8)
" source ~/.vim.Zyffer/plugins.vim  " COMMENTED OUT — empty
source ~/.vim.Zyffer/keybinds.vim  " EMPTY FILE (1 byte)
```

- `plugins.vim` is commented out and empty
- `keybinds.vim` is literally empty (1 byte)
- Only `set.vim` has real content

---

## 5. Scripts Reference

Three executable scripts live in `scripts/` (not stowed, added to `PATH` via zsh).

### tmux-sessionizer

Fzf-based tmux session manager. Searches for projects and creates/attaches
to tmux sessions.

```bash
# Default search paths (hardcoded in script):
#  - ~/me/personal
#  - ~/me/.dotfiles
#  - ~/me/selfhost

# Configurable via tmux-sessionizer.conf
# Triggered in tmux via M-f keybinding
```

### selfhost

Docker Compose helper for `~/me/selfhost/`. Manages self-hosted services.

```bash
selfhost <service> start|stop|restart|status|logs|update|doctor
# Currently manages: searX (search engine)
```

### reshade-linux.sh

Installs ReShade (post-processing injector) on Linux.
~30KB, executable.

---

## 6. Conventions & Philosophy

### Rose-pine-moon Theme

Every visual application uses **rose-pine-moon** (dark purple theme):

| App | How |
|---|---|
| Neovim | rose-pine plugin, `variant = "moon"` |
| WezTerm | `neapsix/wezterm` plugin, `.moon` variant |
| Bat | `--theme="rose-pine-moon"` |
| i3bar | Hardcoded dark Catppuccin-ish colors |
| Bat themes | Bundled `.tmTheme` in `bat/.config/bat/themes/` |

### Git Conventions

- **Commit message:** Always `"hello"` — single message for all changes
- **Force-push is normal** — `git.sh` does `git push -f` to both remotes
- **Two remotes:** `github` (GitHub) and `gitlab` (GitLab)
- **Branch:** `main`
- **No merge commits** — rebase or force-push

### File Conventions

- **No trailing whitespace** (generally)
- **Stow-compatible paths** — files mirror `$HOME` structure
- **Secrets in `secret.zsh`** (gitignored) — never commit API keys

### Design Decisions

- **No mouse in editor** — Neovim has `mouse=""`
- **No AI in editor** — AI is in OpenCode, separate from editing
- **No SaaS** — everything self-hosted or local
- **No fancy bullshit** — no decorative UI, no animations, no eye candy. Everything must have a purpose.
- **No fancy UI plugins** — minimal neovim UI
- **Vi-mode everywhere** — zsh, tmux, neovim all vi-navigation

---

## 7. Danger Zones

### git.sh — FORCE PUSH

```bash
./git.sh
# Does: git add . → git commit -m "hello" → git push -f to BOTH remotes
# Also backs up entire repo to ~/bk/
```

⚠️ This force-pushes everything, including accidental commits.
Always check `git status` and `git diff` before running.
There is **no undo** for a force-push.

### stow --no vs reality

`stow.sh` does NOT do root-level stow (`sudo stow -t /root/`).
Documentation previously claimed it did. If you need root configs,
add them manually.

### Broken References

Some files referenced in the old doc no longer exist:
- `opencode/test_opencode.sh` — deleted
- `opencode/AGENTS.md` — deleted (merged into this file)
- `opencode/context.md` — deleted (merged into this file)
- `opencode/plan.md` — deleted
- `opencode/.stow-local-ignore` — deleted
- `nvim/test_nvim_config.sh` — deleted

Dangling symlinks (`~/.install.log`, `~/.test_opencode.sh`) have been cleaned up.

---

## 8. OpenCode Agent System

### How Agents Work

OpenCode uses a multi-agent system defined in `~/.config/opencode/`.

The **primary agents** (`setup`, `plan`) orchestrate **sub-agents**.
Sub-agents are specialized workers that perform specific tasks.

### Agent Roles

| Agent | Type | Responsibility |
|---|---|---|
| `setup` | Primary | Coordinator — orchestrates the full pipeline |
| `plan` | Primary | Planning & discussion — research-first, no editing |
| `build` | Subagent | Efficient implementation of approved plans |
| `cleanup` | Subagent | Remove dead configs, orphaned symlinks, empty dirs |
| `driver` | Subagent | Propose efficient solutions, cut analysis paralysis |
| `idea-maker` | Subagent | Creative brainstorming, novel approaches |
| `paranoid` | Subagent | Security & risk review |
| `researcher` | Subagent | Read files, search web, document findings |
| `tester` | Subagent | Project review & feedback (does NOT code) |
| `verifier` | Subagent | Plan critique + post-execution verification |

### Skills

Skills provide specialized instructions for common tasks:

| Skill | Trigger |
|---|---|
| `stow` | Stow operations, symlinks, conflicts |
| `shell-config` | Zsh/bash config, plugins, prompt |
| `tmux` | Tmux config, keybindings, plugins |
| `nvim-config` | Neovim config, LSP, plugins |
| `git-workflow` | Git operations, commits, remotes |
| `system-audit` | Auditing system state, dotfile diffs |
| `security-audit` | Security review, secret leakage |
| `idea-generation` | Brainstorming improvements |
| `verifier-checklist` | Post-change verification |

### Workflow

The `setup` agent follows this pipeline:
1. **Explore** — audit current state
2. **Research** — read files, search web, propose changes
3. **Plan Review** — verifier critiques the plan
4. **Test** — tester reviews plan soundness
5. **Execute** — build applies changes
6. **Cleanup** — remove dead files
7. **Verify** — verifier runs checklist

---

## 9. Git & Remotes

### Remote Configuration

| Remote | URL |
|---|---|
| `github` | `git@github.com:Zyffer1/.dotfiles.git` |
| `gitlab` | `git@gitlab.com:Zyffer1/dotfiles.git` |

### Typical Workflow

```bash
# Make changes, then:
git add <files>
git commit -m "hello"
git push -u github main && git push -u gitlab main

# Or use git.sh (⚠️ DANGEROUS — force-pushes everything):
./git.sh
```

### Current Branch

`main` — up to date with `gitlab/main`.

---

## 10. Common Operations Cheatsheet

```bash
# Deploy everything
cd ~/me/.dotfiles && ./stow.sh

# Deploy a single package after editing
stow --restow -t ~ nvim

# Dry-run to check for conflicts
stow --no -t ~ nvim

# Check all packages for conflicts
for pkg in i3 zsh nvim tmux wezterm bat opencode bash picom vim; do
  echo "=== $pkg ==="
  stow --no -v -t ~ "$pkg" 2>&1 || true
done

# Quick git status check
git status

# Commit and push (safe way)
git add -p           # review changes
git commit -m "hello"
git push github main && git push gitlab main

# Keyd symlink (if missing)
sudo ln -s "$HOME/me/.dotfiles/default.conf" /etc/keyd/default.conf

# Reload tmux config (inside tmux)
M-r

# Open tmux sessionizer (inside tmux)
M-f

# Which files are symlinked by stow?
stow -n -v -t ~ nvim 2>&1 | grep LINK
```
