# History settings
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=50000
export HISTFILESIZE=100000
export HISTTIMEFORMAT="%Y-%m-%d %H:%M:%S "
shopt -s histappend
shopt -s histverify

# Core environment
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R -i -w -M -z-4'

# Make less handle colors properly
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"

# XDG Base Directory compliance
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Qt Styles
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=breeze-dark

# Development
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_NOCOWS=1
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# Better defaults
export GREP_OPTIONS='--color=auto'
export GPG_TTY=$(tty)

# Ghostty/terminal specific
export TERM_PROGRAM=ghostty

# PATH additions
export PATH="$HOME/.opencode/bin:$PATH"
