autoload -Uz colors
colors
setopt PROMPT_SUBST

#idk
export EDITOR=nvim
export PATH="$HOME/.local/bin:$PATH"
export TS_SEARCH_PATHS=(~/git:1)
export MANPAGER='nvim +Man!'
export FZF_DEFAULT_OPTS="--bind=ctrl-j:down,ctrl-k:up"

#exstra config
for file in ~/.config/zsh/exstraconf/*.zsh; do
  [ -f "$file" ] && source "$file"
done

#eye candy

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}git:(%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}) %{$fg[white]%}%1{✗%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%})"

PROMPT="%(?:%{$fg_bold[white]%}%1{➜%} :%{$fg_bold[white]%}%1{➜%} ) %{$fg[white]%}%c%{$reset_color%} \$(git_prompt_info)"
#PROMPT='%F{255}%1~%f
#%F{255}➜%f '
#PROMPT=' %F{63}➜%f %F{57}%1~%f '
