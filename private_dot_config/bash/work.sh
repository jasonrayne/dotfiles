# Only load on work machine
if [[ $(hostname) == BSI-US-* ]]; then
  export PATH=$PATH:/usr/local/go/bin
  export TMUX_CONFIG_DIR="$HOME/.config/tmux"
  export OS_CLOUD=biamp-cloud

  eval "$(zoxide init bash)"
  eval "$(starship init bash)"
  . "$HOME/.cargo/env"

  alias claude="/home/jrayne/.claude/local/claude"
fi
