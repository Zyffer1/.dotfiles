#exstra config
for file in ~/.config/zsh/*.zsh; do
  [ -f "$file" ] && source "$file"
done

export PATH=$PATH:$HOME/.spicetify

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# Hermes Agent — ensure ~/.local/bin is on PATH
export PATH="$HOME/.local/bin:$PATH"
