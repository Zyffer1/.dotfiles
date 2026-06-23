---
name: shell-config
description: Use when writing or modifying shell configuration files — .zshrc, .bashrc, .zshenv, plugins, aliases, environment variables, prompt customization. Also when the user asks about zsh plugins, bash completions, or shell theming.
---

# Shell Configuration Patterns

## Structure

This repo manages zsh and bash configs via stow:

- `zsh/` — `.zshrc` at root, plugins under `.config/zsh/plugins/`
- `bash/` — `.bashrc` at root

## Zsh plugins

Plugins live in `.config/zsh/plugins/<name>/`.

To add a plugin:

1. Add it as a subdirectory under `zsh/.config/zsh/plugins/`
2. Source it in `.zshrc`:
   ```zsh
   source "$HOME/.config/zsh/plugins/<name>/<name>.plugin.zsh"
   ```

## Good practices

- Keep `.zshrc` thin — use `source` for feature files
- Export env vars in `.zshenv`, not `.zshrc`
- Use `$HOME/.config/` paths instead of `$HOME/.` for XDG compliance
- Prefer `[[ ]]` over `[ ]` in zsh tests
- Check syntax: `bash -n file.sh`, `zsh -n file.zsh`
