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

# Terminal compatibility for SSH
if [[ -n "$SSH_CONNECTION" ]]; then
  export TERM="xterm-256color"
else
  export TERM="${TERM:-xterm-ghostty}"
fi

# Add ~/.local to PATH
export PATH="$HOME/.local/bin:$PATH"

# ble.sh visual configuration - carbonfox scheme
bleopt color_scheme=carbonfox
bleopt filename_ls_colors="$LS_COLORS"
bleopt complete_auto_complete=1
bleopt complete_auto_history=1
bleopt complete_auto_delay=300

# Visual tweaks
bleopt highlight_syntax=1             # Enable syntax highlighting with carbonfox colors
bleopt highlight_variable=            # No variable highlighting
bleopt highlight_filename=            # No filename highlighting
bleopt complete_menu_color=off        # No menu background colors
bleopt complete_menu_style=desc-raw   # Simple menu style
bleopt complete_menu_color_match=none # No match highlighting
bleopt complete_menu_filter=          # No filter highlighting
bleopt complete_skip_matched=off      # Don't highlight matched portions
bleopt edit_abell=                    # No bell
bleopt canvas_winch_action=clear      # Clean redraws

# Disable ble.sh exit messages
bleopt exec_exit_mark=
bleopt exec_errexit_mark=

# Disable ble.sh key sequence recognition
bleopt decode_error_char_vbell=
bleopt decode_error_cseq_vbell=
bleopt decode_error_kseq_vbell=
bleopt decode_error_kseq_abell=

# Also disable the visual bell entirely
bleopt vbell_duration=0
