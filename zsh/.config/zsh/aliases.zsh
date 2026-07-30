# shortening
alias sozsh='source ~/.zshrc'
alias dl='aria2c -x 16 -s 16 -k 1M'

# gentoo / portage
alias emerge='sudo emerge '
alias dispatch-conf='sudo dispatch-conf'

# better shell utile
alias ls='eza -la --icons --git'
alias tree='eza --tree'
alias grep='grep --color=auto'
alias diff='diff --color=auto'
alias ip='ip -color=auto'
alias help='tldr'
alias fzf='fzf -m --preview="bat --color=always {}"'
alias tailscale='sudo tailscale'
alias mkdir='mkdir -p'
alias free='free -h'
alias df='df -h'
alias du='du -h'
alias ping='ping -c 5'
alias wget='wget --continue'
alias curl='curl -L'
alias xdg-open='xdg-open 2>/dev/null'

#nvim
alias suvi='sudo nvim'
alias vi='nvim'
alias nfzf='nvim $(fzf -m --preview="bat --color=always {}")'

# safty
poweroff() {
  read "answer?Power off the computer? [y/N] "

  case "$answer" in
    y|Y|yes|YES)
      command sudo poweroff
      ;;
    *)
      echo "Cancelled."
      ;;
  esac
}
reboot() {
  read "answer?Reboot the computer? [y/N] "

  case "$answer" in
    y|Y|yes|YES)
      command sudo reboot
      ;;
    *)
      echo "Cancelled."
      ;;
  esac
}
alias cp='cp -i'
alias mv='mv -i'
alias rm='trash -v'
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias ps='ps auxf'
