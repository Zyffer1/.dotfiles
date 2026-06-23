---
name: git-workflow
description: Use when managing git operations for this dotfiles repo — committing, pushing to multiple remotes (origin/GitHub, gitlab), resolving merge conflicts, or reviewing git history. Also when working with git.sh or the GitHub MCP server.
---

# Git Workflow for Dotfiles

## Remotes

This repo typically has two remotes:
- `origin` — GitHub
- `gitlab` — GitLab

## git.sh (dangerous)

```bash
./git.sh   # git add . → git commit -m "hello" → force-push to BOTH remotes
```

**Warnings:**
- Force-pushes (`-f`) — use only when you mean it
- Always check `git status` and `git diff` before running
- The project convention uses generic "hello" commit messages

## Safer workflow

```bash
git status                    # check what's staged
git add <specific files>      # stage only what's intended
git commit -m "descriptive message"
git push origin main          # push to GitHub only
git push gitlab main          # push to GitLab only
```

## GitHub MCP

With the GitHub MCP server, you can:
- Create PRs
- Review issues
- Browse the remote repo
- Manage labels, milestones

Use this instead of `git.sh` for non-trivial operations.
