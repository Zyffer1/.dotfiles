---
name: tmux
description: Use when working with tmux configuration — keybindings, status bar, plugins, sessions, windows, panes. Also when the user mentions tmux.conf, tpm, tmux plugins, or terminal multiplexer setup.
---

# tmux Configuration

## Structure

Config lives at `.config/tmux/tmux.conf` under the `tmux/` stow package.

## Common patterns

### Keybindings

```tmux
# Reload config
bind r source-file ~/.config/tmux/tmux.conf

# Better splitting
bind | split-window -h
bind - split-window -v
```

### Status bar

- Use `status-left` and `status-right` for plugin info
- `status-interval 1` for real-time updates
- Segment colors: `#[fg=color,bg=color]`

### Plugins (TPM)

```tmux
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'tmux-plugins/tmux-sensible'

# Initialize
run '~/.config/tmux/plugins/tpm/tpm'
```

Install with `prefix + I` after adding to config.

### Useful settings

```tmux
set -g mouse on
set -g history-limit 50000
set -g default-terminal "tmux-256color"
set -ga terminal-overrides ",*256col*:Tc"
```
