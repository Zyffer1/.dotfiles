#!/usr/bin/env bash
set -euo pipefail

repo_root="$HOME/me/personal/.dotfiles"

cd "$repo_root"

git add --all

if git diff --cached --quiet; then
  echo "No changes to commit."
  exit 0
fi

git status --short
git commit -m "hello"

for remote in github gitlab; do
  git push -u "$remote" main
done
