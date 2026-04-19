# shortening
alias c='clear'
alias e='exit'
alias hello='yes hello'
alias sozsh='source ~/.zshrc'
alias tmux-myserver='tmux new ssh myserver'

# better shell utile
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fzf='fzf -m --preview="bat --color=always {}"'

#nvim
alias suvi='sudo nvim'
alias vi='nvim'
alias nfzf='nvim $(fzf -m --preview="bat --color=always {}")'
