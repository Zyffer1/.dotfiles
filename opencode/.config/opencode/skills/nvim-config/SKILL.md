---
name: nvim-config
description: Use when working with Neovim configuration — init.lua, lazy.nvim plugins, LSP setup, keymaps, options, filetype detection. Also when the user mentions nvim context.md or plan.md.
---

# Neovim Configuration

## Structure

- **Entrypoint:** `init.lua` → `require("Zyffer")` → loads `keymaps.lua`, `set.lua`, `lazy_init.lua`, `autocmds.lua`, `ftdetect.lua`
- **Plugin manager:** lazy.nvim (auto-bootstrapped from GitHub if missing)
- **Config docs:** `context.md` (philosophy, keymaps, LSP, plugin inventory), `plan.md` (improvement roadmap)

## Key principles

- **Keyboard-only:** `vim.opt.mouse = ""` — no mouse support
- **No AI/Copilot** — no SaaS dependencies
- **No fancy UI** — no noice, no notify, no which-key, no flash
- **Minimal plugin count** — only essential functionality

## LSP

- Uses Neovim 0.11+ `vim.lsp.enable` API (not `lspconfig.manager`)
- Servers lazy-loaded by filetype via `ft` triggers in `lsp_config.lua`
- `lspenable.lua` controls server list, Mason auto-install, custom configs

## Formatting

- conform.nvim for format-on-save
- none-ls for diagnostics only

## Testing

```bash
cd ~/me/.dotfiles/nvim && ./test_nvim_config.sh
```

Tests: boots with all plugins, LSP configs, keymaps, filetype detection. Requires lazy.nvim plugin tree in `~/.local/share/nvim/lazy/`.
