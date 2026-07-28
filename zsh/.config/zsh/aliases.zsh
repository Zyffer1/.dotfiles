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
alias help='tldr'
alias fzf='fzf -m --preview="bat --color=always {}"'
alias tailscale='sudo tailscale'

#nvim
alias suvi='sudo nvim'
alias vi='nvim'
alias nfzf='nvim $(fzf -m --preview="bat --color=always {}")'
