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

# Git fork sync functions
# Assumes standard convention: origin = your fork, upstream = original repo
## Sync fork with upstream before starting work
gss() {
	# Safety checks
	if ! git rev-parse --git-dir >/dev/null 2>&1; then
		echo "❌ Not in a git repository"
		return 1
	fi

	# Check if we're in a git operation state
	local git_dir=$(git rev-parse --git-dir)
	if [[ -f "$git_dir/rebase-merge/interactive" ]] || [[ -d "$git_dir/rebase-apply" ]] || [[ -f "$git_dir/MERGE_HEAD" ]]; then
		echo "❌ Git operation in progress. Complete or abort current rebase/merge first:"
		echo "   git rebase --continue  (after resolving conflicts)"
		echo "   git rebase --abort     (to cancel rebase)"
		echo "   git merge --abort      (to cancel merge)"
		return 1
	fi

	# Check for uncommitted changes
	if ! git diff-index --quiet HEAD -- 2>/dev/null; then
		echo "❌ You have uncommitted changes. Commit or stash them first:"
		git status --porcelain
		echo ""
		echo "💡 Quick fix: git add . && git commit -m 'WIP' or git stash"
		return 1
	fi

	# Check for required remotes
	if ! git remote get-url upstream >/dev/null 2>&1; then
		echo "❌ No 'upstream' remote found. Add it first:"
		echo "   git remote add upstream <upstream-repo-url>"
		return 1
	fi

	if ! git remote get-url origin >/dev/null 2>&1; then
		echo "❌ No 'origin' remote found. Add it first:"
		echo "   git remote add origin <your-fork-url>"
		return 1
	fi

	local current_branch=$(git branch --show-current)

	# Ensure we have a main branch locally
	if ! git show-ref --verify --quiet refs/heads/main; then
		echo "❌ No local 'main' branch found. Create it first:"
		echo "   git checkout -b main upstream/main"
		return 1
	fi

	echo "🔄 Syncing fork with upstream..."
	echo "   Current branch: $current_branch"

	# Fetch with error handling
	if ! git fetch upstream; then
		echo "❌ Failed to fetch from upstream. Check network connection and remote URL."
		return 1
	fi

	echo "📌 Updating local main..."
	if ! git checkout main; then
		echo "❌ Failed to checkout main branch"
		return 1
	fi

	if ! git reset --hard upstream/main; then
		echo "❌ Failed to reset main to upstream/main"
		return 1
	fi

	echo "⬆️  Pushing updated main to fork..."
	if ! git push origin main; then
		echo "❌ Failed to push main to origin. Check push permissions."
		return 1
	fi

	echo "🔀 Rebasing feature branch on updated main..."
	if ! git checkout "$current_branch"; then
		echo "❌ Failed to checkout $current_branch"
		return 1
	fi

	if ! git rebase main; then
		echo "❌ Rebase failed due to conflicts. Resolve them and continue:"
		echo "   1. Edit conflicted files"
		echo "   2. git add <resolved-files>"
		echo "   3. git rebase --continue"
		echo "   Or: git rebase --abort to cancel"
		return 1
	fi

	echo "✅ Ready to work on branch: $current_branch"
}

## Sync fork and push feature branch
gsp() {
	# Safety checks
	if ! git rev-parse --git-dir >/dev/null 2>&1; then
		echo "❌ Not in a git repository"
		return 1
	fi

	local git_dir=$(git rev-parse --git-dir)
	if [[ -f "$git_dir/rebase-merge/interactive" ]] || [[ -d "$git_dir/rebase-apply" ]] || [[ -f "$git_dir/MERGE_HEAD" ]]; then
		echo "❌ Git operation in progress. Complete or abort first."
		return 1
	fi

	if ! git diff-index --quiet HEAD -- 2>/dev/null; then
		echo "❌ You have uncommitted changes. Commit or stash them first:"
		git status --porcelain
		return 1
	fi

	if ! git remote get-url upstream >/dev/null 2>&1; then
		echo "❌ No 'upstream' remote found"
		return 1
	fi

	if ! git remote get-url origin >/dev/null 2>&1; then
		echo "❌ No 'origin' remote found"
		return 1
	fi

	local current_branch=$(git branch --show-current)

	# Prevent pushing from main
	if [[ "$current_branch" == "main" ]]; then
		echo "❌ Cannot push from main branch. Switch to your feature branch first:"
		echo "   git checkout <your-feature-branch>"
		return 1
	fi

	# Show what we're about to do
	echo "⚠️  About to sync and push branch: $current_branch"
	echo "   This will:"
	echo "   • Fetch latest changes from upstream"
	echo "   • Rebase your branch on updated main"
	echo "   • Force-push to your fork (updates PR)"
	echo ""

	read -p "Continue? [y/N]: " -n 1 -r
	echo

	if [[ ! $REPLY =~ ^[Yy]$ ]]; then
		echo "❌ Operation cancelled"
		return 0
	fi

	echo "🔄 Final sync with upstream..."
	if ! git fetch upstream; then
		echo "❌ Failed to fetch from upstream"
		return 1
	fi

	echo "📌 Updating local main..."
	if ! git checkout main; then
		echo "❌ Failed to checkout main"
		return 1
	fi

	if ! git reset --hard upstream/main; then
		echo "❌ Failed to reset main"
		return 1
	fi

	if ! git push origin main; then
		echo "❌ Failed to push main to origin"
		return 1
	fi

	echo "🔀 Rebasing feature branch..."
	if ! git checkout "$current_branch"; then
		echo "❌ Failed to checkout $current_branch"
		return 1
	fi

	if ! git rebase main; then
		echo "❌ Rebase failed. Resolve conflicts and try again:"
		echo "   git add <resolved-files> && git rebase --continue"
		echo "   Then run 'gsp' again"
		return 1
	fi

	echo "🚀 Pushing feature branch to fork..."
	if ! git push origin "$current_branch" --force-with-lease; then
		echo "❌ Failed to push to origin. The branch may have been updated."
		echo "   Run 'git pull origin $current_branch' and try again"
		return 1
	fi

	echo "✅ Feature branch $current_branch successfully pushed to fork"
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
