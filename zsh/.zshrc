#exstra config
for file in ~/.config/zsh/exstraconf/*.zsh; do
  [ -f "$file" ] && source "$file"
done

export PATH=$PATH:$HOME/.spicetify

# >>> Codex installer >>>
export PATH="/home/idk/.local/bin:$PATH"
# <<< Codex installer <<<
