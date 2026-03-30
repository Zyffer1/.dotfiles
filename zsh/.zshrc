#eye candy
autoload -Uz colors
colors

PROMPT='%F{255}➜%f %F{255}%1~%f '
#PROMPT='%F{255}%1~%f
#%F{255}➜%f '
#PROMPT=' %F{63}➜%f %F{57}%1~%f '

#idk
export EDITOR=nvim

#exstra config
for file in ~/.config/zsh/exstraconf/*.zsh; do
  [ -f "$file" ] && source "$file"
done
