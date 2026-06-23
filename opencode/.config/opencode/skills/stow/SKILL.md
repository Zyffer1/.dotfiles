---
name: stow
description: Use when managing GNU Stow dotfile packages — stowing, restowing, unstowing, resolving conflicts, or setting up new packages. Also when the user mentions "stow.sh", "stow conflicts", or symlink issues in their dotfiles repo.
---

# GNU Stow — Dotfiles Management

## Workflow

This repo uses GNU Stow to symlink configs into place.

```bash
# Deploy all packages
./stow.sh

# Deploy a single package
stow -t ~ <package>

# Restow (fix broken symlinks)
stow --restow -t ~ <package>

# Unstow (remove symlinks)
stow -D -t ~ <package>

# Dry-run (see what would happen)
stow --no -t ~ <package>
```

## Adding a new package

```
dotfiles/
├── <package>/
│   └── .config/
│       └── <app>/
│           └── config.file
└── stow.sh
```

1. Create `<package>` directory mirroring the target path
2. Run `stow -t ~ <package>` to symlink
3. Add `<package>` to the `stow` line in `stow.sh`

## Adding a new package (home-level file)

```
dotfiles/
├── <package>/
│   └── .<file>    ← e.g., .zshrc, .gitconfig
└── stow.sh
```

For files directly in `~` (not under `.config/`), place them at the package root.

## Common issues

- **"cannot stow ... over existing target"** — the target exists as a real file, not a symlink. Move it aside: `mv ~/.config/app/config ~/.config/app/config.bak`, then stow.
- **Conflicting stows** — two packages can't both own the same path. Use `--no` to detect conflicts.
- **Broken symlinks** — target moved or deleted. Run `stow --restow -t ~ <package>`.

## `.stow-local-ignore`

Exclude files from stow by adding glob patterns to `.stow-local-ignore` in the package root. Used here to keep `node_modules/`, `package.json`, etc. local.
