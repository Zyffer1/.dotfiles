# shortening
alias c='clear'
alias e='exit'

# better gnu
alias ls='ls --color=auto'
alias grep='grep --color=auto'

#gentoo
alias emerge='sudo emerge -q --ask'

unalias usef 2>/dev/null
confpkgm() {
    if [ -z "$1" ]; then
        sudo nvim /etc/portage/
    else
        sudo nvim /etc/portage/"$1"
    fi
}

findpkgs() {
    if [ -z "$1" ]; then
        echo "Usage: findpkgs <package>"
        return 1
    fi
    /usr/bin/emerge -s "$1" | less
}

#nvim
<<<<<<< HEAD
unalias nv 2>/dev/null

=======
<<<<<<< HEAD
unalias nv 2>/dev/null

=======
>>>>>>> d8e2ad8 (hello)
>>>>>>> 5f75640 (restore local dotfiles)
sunv() {
  if [[ -n "$NVIM" ]]; then
    if [[ $# -eq 0 ]]; then
      command sudo nvim --server "$NVIM" --remote .
    else
      command sudo nvim --server "$NVIM" --remote "$@"
    fi
  else
    if [[ $# -eq 0 ]]; then
      command sudo nvim .
    else
      command sudo nvim "$@"
    fi
  fi
}

nano() {
  if [[ -n "$NVIM" ]]; then
    if [[ $# -eq 0 ]]; then
      command nvim --server "$NVIM" --remote .
    else
      command nvim --server "$NVIM" --remote "$@"
    fi
  else
    if [[ $# -eq 0 ]]; then
      command nvim .
    else
      command nvim "$@"
    fi
  fi
}
