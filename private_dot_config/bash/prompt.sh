# Starship prompt
if command -v starship >/dev/null 2>&1; then
	eval "$(starship init bash)"
else
	# Fallback prompt with git support
	git_branch() {
		git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
	}
	export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\[\033[01;33m\]\$(git_branch)\[\033[00m\]\$ "
fi
