# shortening
alias sozsh='source ~/.zshrc'

# gentoo
alias emerge='sudo emerge '
alias dispatch-conf='sudo dispatch-conf'

# better shell utile
alias ls='eza -la --icons --git'
alias tree='eza --tree'
alias grep='grep --color=auto'
alias help='tldr'
alias fzf='fzf -m --preview="bat --color=always {}"'

#nvim
alias suvi='sudo nvim'
alias vi='nvim'
alias nfzf='nvim $(fzf -m --preview="bat --color=always {}")'
