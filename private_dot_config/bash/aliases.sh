# Core file operations (minimal as requested)
alias ls="eza --icons --group-directories-first"
alias ll="eza -la --icons --group-directories-first --git"
alias la="eza -a --icons --group-directories-first"
alias lt="eza --tree --level=2 --icons"

# Safe operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Basic cat replacement
alias cat='bat'
alias oldcat='/bin/cat'

# Show line numbers (equivalent to cat -n)
alias catn='bat --number'

# Plain output without decorations (equivalent to plain cat)
alias catp='bat --plain'

# Show all characters including non-printable (equivalent to cat -A)
alias cata='bat --show-all'

# Pager disabled for short files (equivalent to cat behavior)
alias catl='bat --paging=never'

# With grid and line numbers for code review
alias catg='bat --style=grid,numbers'

# Navigation helpers
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# System info (perfect for SSH troubleshooting)
alias ports='ss -tulanp'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Network debugging
alias myip='curl -s ipinfo.io/ip'
alias localip="ip route get 1.1.1.1 | awk '{print \$7}'"

# Quick edits
alias bashrc='$EDITOR ~/.bashrc'
alias nvimrc='$EDITOR ~/.config/nvim/init.lua'

# Better diff with delta
alias diff='delta'
alias diffc='delta --side-by-side' # side-by-side view
alias diffn='delta --line-numbers' # with line numbers

# Git shortcuts (but not too many)
alias gs='git status'
alias gl='git log --oneline --graph --decorate --all'
alias gd='git diff'

# Docker/container stuff
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dls='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'

# Openstack
alias os='openstack'

# AI
alias claude="~/.claude/local/claude"
