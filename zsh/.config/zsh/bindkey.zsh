bindkey -M viins '^[[3~' delete-char
bindkey -M vicmd '^[[3~' delete-char

function clear-screen-command() {
    clear
    zle redisplay
}

zle -N clear-screen-command
bindkey '^L' clear-screen-command
