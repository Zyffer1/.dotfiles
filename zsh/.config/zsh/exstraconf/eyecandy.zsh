autoload -Uz colors
colors
setopt PROMPT_SUBST

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}git:(%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}) %{$fg[white]%}%1{✗%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%})"

PROMPT="%(?:%{$fg_bold[white]%}%1{➜%} :%{$fg_bold[white]%}%1{➜%} ) %{$fg[white]%}%c%{$reset_color%} \$(git_prompt_info)"
#PROMPT='%F{255}%1~%f
#%F{255}➜%f '
#PROMPT=' %F{63}➜%f %F{57}%1~%f '
