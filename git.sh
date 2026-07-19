#!/bin/bash

sudo cp /etc/portage/make.conf ~/me/personal/.dotfiles/gentoo/

git add .
git commit -m "hello"
git push -u github main && git push -u gitlab main 
