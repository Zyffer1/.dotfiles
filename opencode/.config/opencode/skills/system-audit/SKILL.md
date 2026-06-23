---
name: system-audit
description: Use when auditing system state — checking which dotfiles exist, what's installed, what configs conflict, what stow packages are deployed, and what's out of sync with the repo. Use when the user asks "what's missing", "what's different", or "audit".
---

# System Audit for Dotfiles

## Check stow deployment

```bash
# List all symlinks created by stow for a package
stow -t ~ -n -v <package>

# Check if a package is deployed
readlink -f ~/.config/<app>/<file> | grep -q "me/.dotfiles" && echo "stowed" || echo "not stowed"
```

## Check what's in the repo

```bash
# List all stow-managed packages
ls -d ~/me/.dotfiles/*/

# List files in a package (relative paths)
cd ~/me/.dotfiles && stow -t ~ -n <package> 2>&1
```

## Find unmanaged configs

```bash
# Find files in ~/.config that aren't symlinks to the repo
find ~/.config -maxdepth 2 -type f ! -readlink -f 2>/dev/null
```

## Check for broken symlinks

```bash
find ~/.config -type l ! -exec test -e {} \; -print 2>/dev/null
```

## Compare system vs repo

For each stow package, check that all repo files have matching symlinks and no expected targets are missing. Use `stow --no` for conflict detection.
