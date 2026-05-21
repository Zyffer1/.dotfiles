# shortening
alias sozsh='source ~/.zshrc'
alias make.conf='sudo nvim /etc/makepkg.conf'

# proj
mkproj() {
    mkdir -p "$PROJECTS/$1"
}
rmproj() {
    if [ -z "$1" ]; then
        echo "Usage: rmproj <project-name>"
        return 1
    fi

    if [ -z "$PROJECTS" ]; then
        echo "Error: PROJECTS is not set"
        return 1
    fi

    rm -ri "$PROJECTS/$1"
}

# rename
alias sudo='doas'

# better shell utile
alias ls='ls -la --color=auto'
alias grep='grep --color=auto'
alias fzf='fzf -m --preview="bat --color=always {}"'
alias clear='clear && neofetch; printf "\n"; printf "\n"'


#nvim
alias suvi='sudo nvim'
alias vi='nvim'
alias nfzf='nvim $(fzf -m --preview="bat --color=always {}")'


#yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
