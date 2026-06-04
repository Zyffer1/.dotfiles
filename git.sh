#!/bin/bash

git add .
git commit -m "hello"
git push -u origin main -f
git push -u gitlab main -f

mkdir -p "$HOME/bk"
cp -r "$PWD" "$HOME/bk"
