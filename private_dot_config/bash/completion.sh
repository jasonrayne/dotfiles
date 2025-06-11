# FZF integration
if [ -f /usr/share/fzf/key-bindings.bash ]; then
    source /usr/share/fzf/key-bindings.bash
fi

if [ -f /usr/share/fzf/completion.bash ]; then
    source /usr/share/fzf/completion.bash
fi

# FZF configuration
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info --ansi"
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# ble.sh for fish-like autocompletion and syntax highlighting
if [ -f ~/.local/share/blesh/ble.sh ]; then
    source ~/.local/share/blesh/ble.sh
fi

# Enhanced readline settings
bind 'set completion-ignore-case on'
bind 'set completion-map-case on'
bind 'set show-all-if-ambiguous on'
bind 'set menu-complete-display-prefix on'
bind 'TAB:menu-complete'
bind 'set colored-stats on'
bind 'set visible-stats on'
bind 'set mark-symlinked-directories on'

# Standard completions
if [ -f /etc/bash_completion ]; then
    source /etc/bash_completion
fi

# Tool-specific completions
if command -v ansible >/dev/null 2>&1; then
    complete -C ansible ansible
    complete -C ansible-playbook ansible-playbook
fi

if command -v terraform >/dev/null 2>&1; then
    complete -C terraform terraform
fi

if [ -f /usr/share/bash-completion/completions/docker ]; then
    source /usr/share/bash-completion/completions/docker
fi

# kubectl completion (if you use it at work)
if command -v kubectl >/dev/null 2>&1; then
    source <(kubectl completion bash)
fi

# Arch/pacman specific completions
if command -v paru >/dev/null 2>&1; then
    complete -cf paru
fi
