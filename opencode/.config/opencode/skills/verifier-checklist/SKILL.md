---
name: verifier-checklist
description: Use when verifying changes — checking symlinks, stow consistency, file integrity, syntax validation, and test execution. The verifier agent should load this skill before running checks.
---

# Verification Checklist

## 1. Symlink integrity
```bash
find ~/.config -type l ! -exec test -e {} \; -print 2>/dev/null
```

## 2. Stow consistency
```bash
cd ~/me/.dotfiles && stow --no -t ~ <package> 2>&1
```

## 3. File content verification
- Read key files to confirm expected content
- Check no unintended changes

## 4. Syntax validation
```bash
python3 -c "import json; json.load(open('file.jsonc'))" 2>&1
bash -n file.sh
```

## 5. Test execution
```bash
cd ~/me/.dotfiles/opencode && ./test_opencode.sh 2>&1
```

## 6. Full deployment check
```bash
cd ~/me/.dotfiles && stow --no -t ~ i3 zsh nvim tmux wezterm bat opencode bash picom vim 2>&1
```

## Sign-off
- ✅ "Verified ✓" — ALL checks pass
- ⚠️ "Verified with notes" — critical pass, minor warnings
- ❌ "Verification failed" — any check fails
