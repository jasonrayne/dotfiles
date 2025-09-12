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
  eval "$(mise activate bash)"

  . "$HOME/.cargo/env"

  alias claude="/home/jrayne/.claude/local/claude"
  alias pynvim="/home/jrayne/.local/bin/pynvim-python"
fi

# OpenStack cloud switchers
## For regular project switching (admin credentials)
os_project() {
  if [ $# -eq 0 ]; then
    echo "Usage: os-switch <project_name>"
    return 1
  fi

  export OS_CLOUD=biamp-cloud # Force back to admin cloud
  export OS_PROJECT_NAME=$1
  export OS_PROJECT_DOMAIN_NAME=default
}

## For app credential switching
os_user() {
  if [ $# -eq 0 ]; then
    echo "Usage: os-user <app_cred_cloud_name>"
    return 1
  fi

  export OS_CLOUD=$1
  unset OS_PROJECT_NAME
  unset OS_PROJECT_DOMAIN_NAME
}

## Aliases
alias os-switch='os_project'
alias os-user='os_user'
