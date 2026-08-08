export EDITOR=nvim
export MANPAGER='nvim +Man!'

typeset -U path PATH

path=(
  "$HOME/.local/bin"
  "$HOME/.spicetify"
  "$HOME/me/personal/.dotfiles/scripts"
  "$HOME/.local/opt/go/bin"
  "$HOME/go/bin"
  "$HOME/.cargo/bin"
  $path
)
