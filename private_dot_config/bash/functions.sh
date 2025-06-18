# Smart cd with auto-ls
cd() {
  builtin cd "$@" && ls
}

# Make directory and cd into it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Find and kill process by name
pskill() {
  ps aux | grep -v grep | grep "$1" | awk '{print $2}' | xargs kill -9
}

# Quick file search
ff() {
  find . -type f -iname "*$1*" 2>/dev/null
}

# Extract any archive
extract() {
  if [ -f "$1" ]; then
    case $1 in
    *.tar.bz2) tar xjf "$1" ;;
    *.tar.gz) tar xzf "$1" ;;
    *.bz2) bunzip2 "$1" ;;
    *.rar) unrar x "$1" ;;
    *.gz) gunzip "$1" ;;
    *.tar) tar xf "$1" ;;
    *.tbz2) tar xjf "$1" ;;
    *.tgz) tar xzf "$1" ;;
    *.zip) unzip "$1" ;;
    *.Z) uncompress "$1" ;;
    *.7z) 7z x "$1" ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Quick backup of files
backup() {
  cp "$1"{,.bak}
}

# Show PATH in readable format
path() {
  echo "$PATH" | tr ':' '\n'
}

# Quick systemctl shortcuts
sctl() {
  case "$1" in
  start | stop | restart | status | enable | disable)
    sudo systemctl "$1" "$2"
    ;;
  *)
    echo "Usage: sctl {start|stop|restart|status|enable|disable} <service>"
    ;;
  esac
}

# tmux session management
tm() {
  if [ -z "$1" ]; then
    tmux list-sessions
  else
    tmux attach-session -t "$1" 2>/dev/null || tmux new-session -s "$1"
  fi
}

# Quick ansible-playbook with common flags
ap() {
  ansible-playbook -i inventory "$1" --diff --check
}

# Run ansible-playbook for real
apr() {
  ansible-playbook -i inventory "$1" --diff
}

# Terraform shortcuts
tf() {
  case "$1" in
  p) terraform plan ;;
  a) terraform apply ;;
  d) terraform destroy ;;
  i) terraform init ;;
  f) terraform fmt ;;
  v) terraform validate ;;
  *) terraform "$@" ;;
  esac
}

# Quick systemd logs
logs() {
  journalctl -fu "$1" --since "10 minutes ago"
}

# Find largest files/directories
largest() {
  du -ah "${1:-.}" | sort -rh | head -20
}

# Port scanner
portscan() {
  nmap -sS -O "$1" 2>/dev/null | grep -E "(open|filtered)"
}

# Network interface quick info
netinfo() {
  echo "Active connections:"
  ss -tuln | grep LISTEN
  echo -e "\nRouting table:"
  ip route | head -5
  echo -e "\nDNS servers:"
  systemd-resolve --status | grep -A1 "DNS Servers" | tail -1
}

# Fuzzy process killer
fkill() {
  local pid
  pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
  if [ "x$pid" != "x" ]; then
    echo "$pid" | xargs kill -"${1:-9}"
  fi
}

# Fuzzy git branch checkout
fco() {
  local branches branch
  branches=$(git branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

# Fuzzy directory jumping with frecency
j() {
  local dir
  dir=$(find ${1:-.} -type d 2>/dev/null | fzf +m) && cd "$dir"
}

# SSH wrapper to enable better Ghostty compatibility
# Disabled while testing new ssh-integration feature
# To be removed once feature is merged upstream
#ssh() {
#  if [[ "$TERM" == "xterm-ghostty" ]]; then
#    TERM=xterm-256color command ssh "$@"
#  else
#    command ssh "$@"
#  fi
#}
