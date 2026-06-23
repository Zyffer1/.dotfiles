# AGENTS.md — dotfiles repo guide

## Stow structure

Every top-level directory under `~/me/.dotfiles/` is a GNU Stow package. The only exceptions are `scripts/` (not stowed; added to `PATH` via zsh) and `.git/`. Top-level files (`stow.sh`, `git.sh`, `README.md`, `install.log`, `default.conf`, `.gitignore`, this file) are also not stowed.

**Packages:** `bash`, `bat`, `i3`, `nvim`, `opencode`, `picom`, `tmux`, `vim`, `wezterm`, `zsh`

## Deployment

```bash
./stow.sh                          # deploy everything (run from repo root)
stow -t ~ <package>                # deploy a single package
stow -D -t ~ <package>             # un-stow a package
stow --no -t ~ <package>           # dry-run before deploying
```

`stow.sh` runs:
- `stow -t ~ i3 zsh nvim tmux wezterm bat opencode`
- `sudo stow -t /root/ zsh nvim` (root-level zsh and nvim configs)
- A manual `sudo ln -s` for `/etc/keyd/default.conf` → `default.conf`

**Root stow requires `sudo`.** Always use `sudo stow -t /root/` for root-target packages.

## Keyd config

`default.conf` is symlinked **outside stow** to `/etc/keyd/default.conf`. If the symlink is missing, run:
```bash
sudo ln -s "$HOME/me/.dotfiles/default.conf" /etc/keyd/default.conf
```

## `git.sh` — dangerous

```bash
./git.sh   # git add . → git commit -m "hello" → force-push to origin AND gitlab
```

This force-pushes (`-f`) to two remotes. Only use when you mean it. The project convention is generic "hello" commit messages. The repo typically has two remotes: `origin` (GitHub) and `gitlab`.

## `.gitignore`

```
zsh/.config/zsh/exstraconf/secret.zsh   # private secrets, never committed
tmux/.tmux/plugins/                      # TPM plugin dir (installed at runtime)
```

## Per-package notes

### `nvim/` — most complex package

- **Entrypoint:** `init.lua` → `require("Zyffer")` → loads `keymaps.lua`, `set.lua`, `lazy_init.lua`, `autocmds.lua`, `ftdetect.lua`
- **Plugin manager:** lazy.nvim (auto-bootstrapped from GitHub if missing)
- **Config docs:** `context.md` (philosophy, keymaps, LSP, plugin inventory), `plan.md` (improvement roadmap)
- **Zen:** keyboard-only (`vim.opt.mouse = ""`), no AI/Copilot, no SaaS, no fancy UI plugins (no noice, no notify, no which-key, no flash)
- **LSP:** Uses Neovim 0.11+ `vim.lsp.enable` API (not `lspconfig.manager`). Servers lazy-loaded by filetype via `ft` triggers in `lsp_config.lua`. `lspenable.lua` controls server list, Mason auto-install, and custom configs.
- **Formatting:** conform.nvim (format-on-save), none-ls for diagnostics only
- **Test:** `test_nvim_config.sh` — proves the config boots with all plugins, LSP configs, keymaps, and filetype detection. Requires the real lazy.nvim plugin tree in `~/.local/share/nvim/lazy/` (copies it into a temp sandbox). Also runs `nixfmt` and `gofmt` smoke tests if available.

```bash
cd ~/me/.dotfiles/nvim && ./test_nvim_config.sh
```

### `zsh/`

- **Entrypoint:** `.zshrc` → sources all `~/.config/zsh/exstraconf/*.zsh`
- **Extra modules:** `aliases.zsh` (ls, grep, fzf, nvim, nixvi), `expots.zsh` (PATH, EDITOR, MANPAGER), `eyecandy.zsh` (prompt with git info), `git.zsh` (git_prompt_info function), `hist.zsh` (history settings), `menulist.zsh` (completion), `sourceingplugins.zsh` (zsh-autosuggestions, zsh-syntax-highlighting, zoxide, fzf), `vi(mode).zsh` (vi-mode, cursor shapes)
- **Plugins dir:** `~/.config/zsh/plugins/` — contains vendored zsh plugins (zsh-autosuggestions, zsh-syntax-highlighting, git.plugin.zsh). These are installed/runtime only.
- `secret.zsh` is gitignored — place personal secrets there (sourced automatically).

### `tmux/`

- **Entrypoint:** `~/.config/tmux/tmux.conf`
- **Plugins:** TPM (tmux-plugins/tpm), tmux-sensible, vim-tmux-navigator, tmux-autoreload
- **TPM dir:** `~/.tmux/plugins/` — gitignored; install with `prefix + I` after first deploy
- **Reload:** `M-r` sources `~/.config/tmux/tmux.conf`
- **Sessionizer:** `M-f` runs `~/me/.dotfiles/scripts/tmux-sessionizer`

### `scripts/` (not stowed, in PATH)

- `tmux-sessionizer` — fzf-based tmux session manager. Default search paths in script: `~/me/personal`, `~/me/.dotfiles`, `~/me/selfhost`. Configurable via `tmux-sessionizer.conf`.
- `selfhost` — Docker Compose helper for `~/me/selfhost/`. Manages services (currently searX). Usage: `selfhost <service> start|stop|restart|status|logs|update|doctor`.
- `reshade-linux.sh` — reshade installer for Linux.

### `wezterm/`

- **Config:** `wezterm.lua` — rose-pine-moon theme (fetched via wezterm plugin), no tab bar, 120×28 initial size, font size 22, JetBrains Mono, transparency (opacity 0.0), 165 FPS, Wayland disabled.

### `i3/`

- **Config:** `~/.config/i3/config` — Mod4 (Super) modifier, rofi launcher, i3status bar, rose-pine themed bar colors, workspace binding to DP-3/HDMI-1, picom compositor launched on startup. Separate `i3status/` config.

### `bat/`

- **Config:** `~/.config/bat/config` — theme `rose-pine-moon`. Themes bundled under `.config/bat/themes/`.

### `picom/`

- **Config:** `picom.conf` — GLX backend, dual_kawase blur, 80% opacity for WezTerm.

### `vim/` — legacy/stale

- Mostly commented out. `.vimrc` sources three files from `.vim.Zyffer/` but `plugins.vim` is empty (no vim-plug plugins loaded) and `keybinds.vim` is empty. `set.vim` has basic options (numbers, 2-space indent, no mouse, scrolloff=8, colorcolumn=80).

### `bash/`

- Minimal `.bashrc` — colorized ls/grep, clear also runs neofetch. Used as a fallback when zsh is unavailable.

### `opencode/`

- OpenCode agent configuration. Deployed via stow to `~/.config/opencode/`.
- `opencode.jsonc` — MCP servers (Playwright browser, SearXNG web search).
- `agents/` — definitions for `setup` (primary), `driver`, `paranoid`, `tester`, `verifier`.
- `skills/` — bundled skill files for shell-config, stow, system-audit, tmux.
- `AGENTS.md` in this dir documents the agent architecture (separate from this repo-level guide).
- `.stow-local-ignore` excludes `node_modules`, `package.json`, `package-lock.json`, `bun.lock`, `AGENTS.md`, `context.md`, `plan.md` from stow.

## Common operations

```bash
# Deploy everything
cd ~/me/.dotfiles && ./stow.sh

# Deploy a single package after editing
stow --restow -t ~ nvim

# Dry-run to check for conflicts
stow --no -t ~ nvim

# Test nvim config
cd ~/me/.dotfiles/nvim && ./test_nvim_config.sh

# Check stow is happy across all packages
for pkg in i3 zsh nvim tmux wezterm bat opencode bash picom vim; do
  echo "=== $pkg ==="
  stow --no -v -t ~ "$pkg" 2>&1 || true
done
```

## Rose-pine-moon theme

Every visual application in this repo uses **rose-pine-moon**:
- **nvim:** `rose-pine` plugin, `variant = "moon"`
- **wezterm:** `neapsix/wezterm` plugin, `.moon` variant
- **bat:** `--theme="rose-pine-moon"`
- **i3bar:** hardcoded Catppuccin-ish colors in bar config (not strictly rose-pine but dark-toned)
- **bat themes:** Bundled `.tmTheme` files in `bat/.config/bat/themes/`
