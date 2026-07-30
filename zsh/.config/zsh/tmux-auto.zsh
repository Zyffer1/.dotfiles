_zsh_tmux_auto_attach() {
  [[ -n "$TMUX" ]] && return
  [[ -n "$TMUX_DISABLE" ]] && return
  command -v tmux &>/dev/null || return
  if ! tmux has-session -t main 2>/dev/null; then
    tmux new-session -d -s main 2>/dev/null
  fi
  tmux attach-session -t main
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _zsh_tmux_auto_attach

if [[ -z "$TMUX" ]] && [[ -z "$TMUX_DISABLE" ]] && command -v tmux &>/dev/null; then
  tmux new-session -A -s main
fi
