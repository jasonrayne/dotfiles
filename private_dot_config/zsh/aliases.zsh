# ZSH global aliases (these are powerful - use carefully)
alias -g L='| less'
alias -g G='| grep'
alias -g H='| head'
alias -g T='| tail'
alias -g N='> /dev/null'
alias -g S='| sort'
alias -g U='| sort -u'
alias -g R='| sort -r'
alias -g C='| wc -l'
alias -g X='| xargs'
alias -g J='| jq'
alias -g Y='| yq'

# History shortcuts
alias history='history 1'
alias h='history | grep'

# Directory stack shortcuts (ZSH pushd/popd)
alias d='dirs -v'
alias 1='cd -'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'

# Process shortcuts
alias psg='ps aux | grep'

# ZSH config editing
alias zshrc='$EDITOR ~/.zshrc'
alias zshconf='$EDITOR ~/.config/zsh/'

# File operations with exa
alias ls="exa --icons --group-directories-first"
alias ll="exa -la --icons --group-directories-first --git"
alias la="exa -a --icons --group-directories-first"
alias lt="exa --tree --level=2 --icons"

# Interactive prompts for destructive operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Directory navigation (keep minimal set - AUTO_CD handles most)
alias ..='cd ..'

# System monitoring shortcuts
alias ports='ss -tulanp'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'

# Network utilities
alias myip='curl -s ipinfo.io/ip'
alias localip="ip route get 1.1.1.1 | awk '{print \$7}'"

# Docker formatting
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"'
alias dls='docker images --format "table {{.Repository}}\t{{.Tag}}\t{{.Size}}"'

# Development build of Ghostty
alias ghostty-dev='env GHOSTTY_RESOURCES_DIR="$HOME/.local/ghostty-dev/share/ghostty" PATH="$HOME/.local/ghostty-dev/bin:$PATH" $HOME/.local/ghostty-dev/bin/ghostty'
