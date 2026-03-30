git_prompt_info() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return 0

  local branch

  branch=$(
    command git symbolic-ref --quiet --short HEAD 2>/dev/null ||
    command git rev-parse --short HEAD 2>/dev/null
  ) || return 0

  if ! command git diff --quiet 2>/dev/null || ! command git diff --cached --quiet 2>/dev/null; then
    printf '%s%s%s ' \
      "$ZSH_THEME_GIT_PROMPT_PREFIX" \
      "$branch" \
      "$ZSH_THEME_GIT_PROMPT_DIRTY"
  else
    printf '%s%s%s%s ' \
      "$ZSH_THEME_GIT_PROMPT_PREFIX" \
      "$branch" \
      "$ZSH_THEME_GIT_PROMPT_CLEAN" \
      "$ZSH_THEME_GIT_PROMPT_SUFFIX"
  fi
}
