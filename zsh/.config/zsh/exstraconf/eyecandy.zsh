autoload -Uz colors
colors
setopt PROMPT_SUBST

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[white]%})"

PROMPT="%F{blue}%/%f \$(git_prompt_info)
%(?.%F{green}❯%f .%F{red}❯%f )"

TRANSIENT_PROMPT='%F{gray}❯%f '

_transient_prompt_accept_line() {
  local old_prompt=$PROMPT

  PROMPT=$TRANSIENT_PROMPT
  zle reset-prompt

  PROMPT=$old_prompt
  zle .accept-line
}

zle -N accept-line _transient_prompt_accept_line
