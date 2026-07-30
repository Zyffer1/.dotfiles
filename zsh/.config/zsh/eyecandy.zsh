autoload -Uz colors
colors
setopt PROMPT_SUBST

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}x%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%})"

PROMPT="%F{green}%1~%f \$(git_prompt_info)%(?.%F{blue}❯%f .%F{red}❯%f )"
