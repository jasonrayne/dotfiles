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
#if [ -f /usr/share/blesh/ble.sh ]; then
#	source /usr/share/blesh/ble.sh
#fi

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

## ble.sh visual configuration - carbonfox scheme
#bleopt color_scheme=carbonfox
#bleopt filename_ls_colors="$LS_COLORS"
#bleopt complete_auto_complete=1
#bleopt complete_auto_history=1
#bleopt complete_auto_delay=300
#
## Visual tweaks
#bleopt highlight_syntax=1             # Enable syntax highlighting with carbonfox colors
#bleopt highlight_variable=            # No variable highlighting
#bleopt highlight_filename=            # No filename highlighting
#bleopt complete_menu_color=off        # No menu background colors
#bleopt complete_menu_style=desc-raw   # Simple menu style
#bleopt complete_menu_color_match=none # No match highlighting
#bleopt complete_menu_filter=          # No filter highlighting
#bleopt complete_skip_matched=off      # Don't highlight matched portions
#bleopt edit_abell=                    # No bell
#bleopt canvas_winch_action=clear      # Clean redraws
#
## Disable ble.sh exit messages
#bleopt exec_exit_mark=
#bleopt exec_errexit_mark=
#
## Disable ble.sh key sequence recognition
#bleopt decode_error_char_vbell=
#bleopt decode_error_cseq_vbell=
#bleopt decode_error_kseq_vbell=
#bleopt decode_error_kseq_abell=
#
## Also disable the visual bell entirely
#bleopt vbell_duration=0
