# shortening
alias sozsh='source ~/.zshrc'

# better shell utile
alias ls='ls -lah --color=auto'
alias grep='grep --color=auto'
alias fzf='fzf -m --preview="bat --color=always {}"'

#nvim
alias suvi='sudo nvim'
alias vi='nvim'
alias nfzf='nvim $(fzf -m --preview="bat --color=always {}")'
