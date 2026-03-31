# shortening
alias c='clear'
alias e='exit'
alias hello='yes hello'

# better shell utile
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fzf='fzf -m --preview="bat --color=always {}"'

#nvim
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

alias nfzf='nvim $(fzf -m --preview="bat --color=always {}")'
