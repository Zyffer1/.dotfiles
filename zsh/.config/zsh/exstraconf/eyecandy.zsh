autoload -Uz colors
colors
setopt PROMPT_SUBST

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}git:(%{$fg[white]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[white]%}) %{$fg[white]%}%1{✗%}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%})"

PROMPT="%{$fg[white]%}%/%{$reset_color%} \$(git_prompt_info)
%(?:%{$fg_bold[white]%}%1{❯%} :%{$fg_bold[white]%}%1{❯%} )"

TRANSIENT_PROMPT='%F{white}❯%f '

_transient_prompt_accept_line() {
  local old_prompt=$PROMPT

  PROMPT=$TRANSIENT_PROMPT
  zle reset-prompt

  PROMPT=$old_prompt
  zle .accept-line
}

zle -N accept-line _transient_prompt_accept_line
