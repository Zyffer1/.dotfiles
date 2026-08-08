# .dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

**Theme:** rose-pine-moon (dark purple) everywhere.
**Philosophy:** Minimal, keyboard-driven, no bloat.

## Quick Start

```bash
git clone git@github.com:Zyffer1/.dotfiles.git ~/me/personal/.dotfiles
cd ~/me/personal/.dotfiles
./stow.sh
```

## Packages

| Package | What it configures |
|---|---|
| `zsh` | Primary shell (aliases, vi-mode, autosuggestions, syntax highlighting) |
| `nvim` | Neovim with lazy.nvim and 14 LSP servers |
| `tmux` | Terminal multiplexer with TPM, vim-tmux-navigator, sessionizer |
| `wezterm` | Terminal emulator (rose-pine-moon) |
| `i3` | Window manager (rofi, picom, i3status) |
| `bat` | Cat clone with rose-pine-moon theme |
| `opencode` | AI coding assistant config (MCP servers, agents) |
| `picom` | Compositor (dual_kawase blur, 80% wezterm opacity) |
| `bash` | Fallback shell (minimal config) |
| `vim` | Legacy Vim config (mostly stale) |

## Scripts (in PATH)

- `tmux-sessionizer` — fzf-based tmux session switcher
- `selfhost` — Docker Compose helper for self-hosted services
- `reshade-linux.sh` — ReShade installer for Linux

## Git

Two remotes — [GitHub](https://github.com/Zyffer1/.dotfiles) and [GitLab](https://gitlab.com/Zyffer1/dotfiles).
Commit style: always `"hello"`.

## For AI Agents

See [AGENTS.md](./AGENTS.md) for the complete repository guide — every package,
script, convention, and danger zone documented for AI consumption.
