#!/bin/bash

git add .
git commit -m "hello"
git push -u github main && git push -u gitlab main 

mkdir -p "$HOME/bk"
cp -r "$PWD" "$HOME/bk"
