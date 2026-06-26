#exstra config
for file in ~/.config/zsh/exstraconf/*.zsh; do
  [ -f "$file" ] && source "$file"
done
