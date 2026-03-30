#menu list
autoload -Uz compinit
compinit

zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' completer _extensions _complete _approximate
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
setopt GLOB_DOTS

# keybind for completion menu
bindkey -M menuselect 'h' backward-char
bindkey -M menuselect 'l' forward-char
bindkey -M menuselect 'j' down-line-or-history
bindkey -M menuselect 'k' up-line-or-history
bindkey '^I' complete-word

