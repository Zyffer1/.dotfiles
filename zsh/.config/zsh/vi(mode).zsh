#vi mod
bindkey -v
KEYTIMEOUT=1
export VI_MODE_SET_CURSOR=true

#vi mode keys
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins 'kj' vi-cmd-mode

#cursor change in vi mode
function zle-keymap-select {
  if [[ $KEYMAP == vicmd ]]; then
    echo -ne '\e[1 q'
  else
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select

function zle-line-init {
  echo -ne '\e[5 q'
}
zle -N zle-line-init

#edit lines in vim with ctrl+e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

#history substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
