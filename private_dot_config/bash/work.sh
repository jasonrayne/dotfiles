# Only load on work machine
if [[ $(hostname) == BSI-US-* ]]; then
  source /usr/share/doc/fzf/examples/key-bindings.bash
  source <(openstack complete 2>/dev/null)

  export PATH=$PATH:/usr/local/go/bin
  export TMUX_CONFIG_DIR="$HOME/.config/tmux"
  export OS_CLOUD=biamp-cloud
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  eval "$(zoxide init bash)"
  eval "$(starship init bash)"
  . "$HOME/.cargo/env"

  alias claude="/home/jrayne/.claude/local/claude"
  alias pynvim="/home/jrayne/.local/bin/pynvim-python"
fi
