fpath=(/usr/share/zsh/site-functions $fpath)

source /usr/share/zsh/site-functions/fzf-tab.zsh

source /usr/share/zsh/site-functions/zsh-autosuggestions.zsh
source /usr/share/zsh/site-functions/_zsh-history-substring-search

eval "$(zoxide init --cmd cd zsh)"
source <(fzf --zsh)

source /usr/share/zsh/site-functions/zsh-syntax-highlighting.zsh
