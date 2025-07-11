# History configuration (sizes only - behavior set in base.zsh)
export HISTSIZE=50000
export SAVEHIST=100000
export HISTFILE="$HOME/.zsh_history"

# Default programs
export EDITOR=nvim
export VISUAL=nvim
export PAGER=less
export LESS='-R -i -w -M -z-4'

# Syntax highlighting in less
export LESSOPEN="| /usr/bin/highlight -O ansi %s 2>/dev/null"

# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"

# Qt theming
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=breeze-dark

# Development tools
export ANSIBLE_HOST_KEY_CHECKING=False
export ANSIBLE_NOCOWS=1
export TF_PLUGIN_CACHE_DIR="$HOME/.terraform.d/plugin-cache"

# Colorized output
export GREP_OPTIONS='--color=auto'
export GPG_TTY=$(tty)

# CachyOS gaming optimizations
export PROTON_ENABLE_WAYLAND=1

# Terminal identification
export TERM_PROGRAM=ghostty

# User binaries
export PATH="$HOME/.local/bin:$PATH"
