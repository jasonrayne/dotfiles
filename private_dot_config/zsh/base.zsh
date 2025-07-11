# Oh-my-zsh configuration
export ZSH="/usr/share/oh-my-zsh"

# Oh-my-zsh settings
DISABLE_MAGIC_FUNCTIONS="true"
ENABLE_CORRECTION="true"
COMPLETION_WAITING_DOTS="true"

# Plugins - order matters
plugins=(
    git
    fzf 
    extract
    docker
    terraform
    kubectl
    ansible
)

source $ZSH/oh-my-zsh.sh

# ZSH behavior options
setopt AUTO_CD                 # cd by typing directory name
setopt AUTO_PUSHD             # cd pushes to directory stack
setopt PUSHD_IGNORE_DUPS      # don't duplicate directories in stack
setopt CORRECT                # command correction
setopt EXTENDED_GLOB          # extended globbing
setopt GLOB_DOTS              # glob dotfiles
setopt HIST_REDUCE_BLANKS     # clean up history entries
setopt SHARE_HISTORY          # share history across sessions
setopt APPEND_HISTORY         # append to history file
setopt INC_APPEND_HISTORY     # write history immediately
setopt EXTENDED_HISTORY       # timestamps in history
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_IGNORE_DUPS       # ignore consecutive duplicates
setopt HIST_IGNORE_ALL_DUPS   # ignore all duplicates
setopt HIST_FIND_NO_DUPS      # don't find duplicates in search
setopt HIST_SAVE_NO_DUPS      # don't save duplicates

# Completion improvements
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive
zstyle ':completion:*' menu select                        # menu selection
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"   # colored listings

# FZF integration (modern approach)
if command -v fzf >/dev/null 2>&1; then
    eval "$(fzf --zsh)"
    export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border --inline-info --ansi"
    export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi

# Zoxide (better than z plugin)
if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

# CachyOS-specific enhancements
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh
source /usr/share/doc/pkgfile/command-not-found.zsh

# CachyOS-specific aliases
alias make="make -j$(nproc)"
alias ninja="ninja -j$(nproc)"
alias n="ninja"
alias c="clear"
alias rmpkg="sudo pacman -Rsn"
alias cleanch="sudo pacman -Scc"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias update="sudo pacman -Syu"
alias cleanup="sudo pacman -Rsn \$(pacman -Qtdq)"
alias jctl="journalctl -p 3 -xb"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -201 | nl"

# Custom `less` colors for `man` pages
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias update="sudo pacman -Syu"
alias cleanup="sudo pacman -Rsn \$(pacman -Qtdq)"
alias jctl="journalctl -p 3 -xb"
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

# Custom `less` colors for `man` pages
export LESS_TERMCAP_md="$(tput bold 2> /dev/null; tput setaf 2 2> /dev/null)"
export LESS_TERMCAP_me="$(tput sgr0 2> /dev/null)"
