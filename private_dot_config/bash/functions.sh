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

# Git fork sync functions - Enhanced for fast-moving upstream
# Assumes standard convention: origin = your fork, upstream = original repo

## Sync fork with upstream (clean feature branches, preserve commit history)
gss() {
	local auto_stash=false
	local quick_mode=false
	local merge_strategy=true

	# Parse flags
	while [[ $# -gt 0 ]]; do
		case $1 in
		-s | --stash)
			auto_stash=true
			shift
			;;
		-q | --quick)
			quick_mode=true
			shift
			;;
		-m | --merge)
			merge_strategy=true
			shift
			;;
		-h | --help)
			echo "Usage: gss [OPTIONS]"
			echo ""
			echo "Default: Uses rebase to keep feature branch clean"
			echo ""
			echo "Options:"
			echo "  -s, --stash    Auto-stash uncommitted changes"
			echo "  -q, --quick    Skip safety prompts for fast sync"
			echo "  -m, --merge    Use merge instead of rebase (when conflicts are complex)"
			echo "  -h, --help     Show this help"
			return 0
			;;
		*)
			echo "Unknown option: $1"
			return 1
			;;
		esac
	done

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
	local has_changes=false
	local stash_created=false

	# Handle uncommitted changes
	if ! git diff-index --quiet HEAD -- 2>/dev/null; then
		has_changes=true

		if [[ "$auto_stash" == "true" ]]; then
			echo "📦 Auto-stashing uncommitted changes..."
			if git stash push -m "gss auto-stash $(date '+%Y-%m-%d %H:%M:%S')"; then
				stash_created=true
				echo "✅ Changes stashed"
			else
				echo "❌ Failed to stash changes"
				return 1
			fi
		elif [[ "$quick_mode" == "false" ]]; then
			echo "⚠️  You have uncommitted changes:"
			git status --porcelain | head -10
			if [[ $(git status --porcelain | wc -l) -gt 10 ]]; then
				echo "... and $(($(git status --porcelain | wc -l) - 10)) more files"
			fi
			echo ""
			echo "Options:"
			echo "  1. gss --stash    (auto-stash and restore after sync)"
			echo "  2. git stash      (manual stash)"
			echo "  3. git add . && git commit -m 'WIP'"
			return 1
		else
			# Quick mode with changes - auto-stash
			if git stash push -m "gss quick auto-stash $(date '+%Y-%m-%d %H:%M:%S')"; then
				stash_created=true
				echo "📦 Quick mode: auto-stashed changes"
			else
				echo "❌ Failed to stash changes"
				return 1
			fi
		fi
	fi

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
		# Restore stash if we created one
		if [[ "$stash_created" == "true" ]]; then
			echo "🔄 Restoring stashed changes..."
			git stash pop
		fi
		return 1
	fi

	# Show how far behind we are
	local behind_count=$(git rev-list --count main..upstream/main 2>/dev/null || echo "0")
	if [[ "$behind_count" -gt 0 ]]; then
		echo "📈 Main is $behind_count commits behind upstream"
	else
		echo "✅ Main is up to date with upstream"
	fi

	echo "📌 Updating local main..."
	if ! git checkout main; then
		echo "❌ Failed to checkout main branch"
		if [[ "$stash_created" == "true" ]]; then
			git checkout "$current_branch"
			git stash pop
		fi
		return 1
	fi

	if ! git reset --hard upstream/main; then
		echo "❌ Failed to reset main to upstream/main"
		if [[ "$stash_created" == "true" ]]; then
			git checkout "$current_branch"
			git stash pop
		fi
		return 1
	fi

	echo "⬆️  Pushing updated main to fork..."
	if ! git push origin main; then
		echo "❌ Failed to push main to origin. Check push permissions."
		if [[ "$stash_created" == "true" ]]; then
			git checkout "$current_branch"
			git stash pop
		fi
		return 1
	fi

	# Switch back to feature branch
	if ! git checkout "$current_branch"; then
		echo "❌ Failed to checkout $current_branch"
		if [[ "$stash_created" == "true" ]]; then
			git stash pop
		fi
		return 1
	fi

	# Show rebase/merge preview if there are commits to integrate
	local commits_to_integrate=$(git rev-list --count main.."$current_branch" 2>/dev/null || echo "0")
	if [[ "$commits_to_integrate" -gt 0 ]]; then
		if [[ "$merge_strategy" == "false" ]]; then
			# Default: rebase strategy for clean feature branch
			echo "🔀 Will rebase $commits_to_integrate commits on updated main..."
			if [[ "$commits_to_integrate" -gt 10 && "$quick_mode" == "false" ]]; then
				echo "⚠️  Rebasing $commits_to_integrate commits may cause conflicts."
				echo "   Alternative: gss --merge (creates merge commit in feature branch)"
				echo ""
				read -p "Continue with rebase? [Y/n]: " -n 1 -r
				echo
				if [[ $REPLY =~ ^[Nn]$ ]]; then
					echo "❌ Operation cancelled"
					if [[ "$stash_created" == "true" ]]; then
						git stash pop
					fi
					return 0
				fi
			fi

			if ! git rebase main; then
				echo "❌ Rebase failed due to conflicts. Resolve them and continue:"
				echo "   1. Edit conflicted files"
				echo "   2. git add <resolved-files>"
				echo "   3. git rebase --continue"
				echo "   Or: git rebase --abort to cancel"
				if [[ "$stash_created" == "true" ]]; then
					echo ""
					echo "⚠️  Your stashed changes are still available: git stash pop"
				fi
				return 1
			fi
		else
			# Opt-in: merge strategy (creates merge commit in feature branch)
			echo "🔀 Merging $commits_to_integrate commits with updated main..."
			echo "   • Creates merge commit in feature branch"
			echo "   • Use only when rebase conflicts are too complex"

			if ! git merge main; then
				echo "❌ Merge failed due to conflicts. Resolve them and continue:"
				echo "   1. Edit conflicted files"
				echo "   2. git add <resolved-files>"
				echo "   3. git commit"
				echo "   Or: git merge --abort to cancel"
				if [[ "$stash_created" == "true" ]]; then
					echo ""
					echo "⚠️  Your stashed changes are still available: git stash pop"
				fi
				return 1
			fi
		fi
	else
		echo "ℹ️  No commits to integrate on $current_branch"
	fi

	# Restore stashed changes if we created a stash
	if [[ "$stash_created" == "true" ]]; then
		echo "🔄 Restoring stashed changes..."
		if git stash pop; then
			echo "✅ Stashed changes restored"
		else
			echo "⚠️  Failed to restore stash automatically. Your changes are in stash:"
			echo "   git stash list"
			echo "   git stash pop  (when ready)"
		fi
	fi

	echo "✅ Ready to work on branch: $current_branch"
}

## Quick sync shortcut - for frequent updates during active development
gsq() {
	gss --stash --quick "$@"
}

## Quick merge sync - for when rebase conflicts are too complex
gsm() {
	gss --stash --quick --merge "$@"
}

## Sync fork and push feature branch (preserve commit granularity for better git bisect)
gsp() {
	local force_push=false
	local sync_first=true
	local merge_strategy=false
	local cleanup_wip=false

	# Parse flags
	while [[ $# -gt 0 ]]; do
		case $1 in
		-f | --force)
			force_push=true
			shift
			;;
		--no-sync)
			sync_first=false
			shift
			;;
		--merge)
			merge_strategy=true
			shift
			;;
		--cleanup-wip)
			cleanup_wip=true
			shift
			;;
		-h | --help)
			echo "Usage: gsp [OPTIONS]"
			echo ""
			echo "Default: Uses rebase to keep feature branch clean"
			echo ""
			echo "Options:"
			echo "  -f, --force      Skip confirmation prompt"
			echo "  --no-sync        Skip upstream sync (push current state)"
			echo "  --merge          Use merge instead of rebase (when conflicts are complex)"
			echo "  --cleanup-wip    Interactive rebase to clean up WIP commits first"
			echo "  -h, --help       Show this help"
			echo ""
			echo "Philosophy: Keep individual commits for Mitchell's git bisect preference."
			echo "Each commit should build and represent meaningful progress."
			return 0
			;;
		*)
			echo "Unknown option: $1"
			return 1
			;;
		esac
	done

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

	# Offer WIP cleanup if there are many small commits
	local total_commits=$(git rev-list --count main.."$current_branch" 2>/dev/null || echo "0")
	if [[ "$cleanup_wip" == "true" ]]; then
		echo "🧹 Cleaning up WIP commits with interactive rebase..."
		echo "   Look for: consecutive 'WIP', 'fix', 'oops' commits to squash"
		echo "   Keep: meaningful commits that represent logical progress"
		echo ""
		if ! git rebase -i main; then
			echo "❌ Interactive rebase failed. Complete or abort:"
			echo "   git rebase --continue  (after editing)"
			echo "   git rebase --abort     (to cancel)"
			return 1
		fi
		echo "✅ WIP cleanup completed"
		# Recalculate commit count after cleanup
		total_commits=$(git rev-list --count main.."$current_branch" 2>/dev/null || echo "0")
	fi

	# Check for potential WIP commit patterns and suggest cleanup
	if [[ "$total_commits" -gt 5 && "$cleanup_wip" == "false" ]]; then
		local wip_count=$(git log --oneline main.."$current_branch" | grep -iE "(wip|fix|oops|temp)" | wc -l)
		if [[ "$wip_count" -gt 3 ]]; then
			echo "💡 Detected $wip_count potential WIP commits out of $total_commits total"
			echo "   Consider: gsp --cleanup-wip (to clean up before push)"
			echo "   Best practice: small, meaningful commits that each build successfully"
			echo ""
		fi
	fi

	# Sync with upstream first (unless disabled)
	if [[ "$sync_first" == "true" ]]; then
		echo "🔄 Syncing with upstream first..."
		local gss_args="--quick"
		if [[ "$merge_strategy" == "true" ]]; then
			# Only add --merge flag when explicitly requested
			gss_args="$gss_args --merge"
		fi
		# Default is rebase strategy (no flag needed)

		if ! gss $gss_args; then
			echo "❌ Sync failed. Fix issues and try again."
			return 1
		fi
		echo ""
	fi

	# Show what we're about to push
	local commits_ahead=$(git rev-list --count origin/"$current_branch".."$current_branch" 2>/dev/null || echo "new")
	local commits_behind=$(git rev-list --count "$current_branch"..origin/"$current_branch" 2>/dev/null || echo "0")
	local branch_commits=$(git rev-list --count main.."$current_branch" 2>/dev/null || echo "0")

	echo "🚀 Ready to push branch: $current_branch"
	if [[ "$commits_ahead" == "new" ]]; then
		echo "   • New branch (first push)"
		echo "   • $branch_commits commits total"
	else
		echo "   • $commits_ahead commits ahead of origin"
		echo "   • $branch_commits commits from main"
		if [[ "$commits_behind" -gt 0 ]]; then
			echo "   • $commits_behind commits behind origin (will force-push)"
		fi
	fi

	# Git best practices reminder
	if [[ "$branch_commits" -gt 0 ]]; then
		echo ""
		echo "📝 Commit best practices check:"
		echo "   ✓ Each commit should build successfully"
		echo "   ✓ Commits represent meaningful progress (not just WIP)"
		echo "   ✓ Good for git bisect (granular, logical changes)"
		if [[ "$merge_strategy" == "false" ]]; then
			echo "   ✓ Using rebase to keep feature branch clean"
			echo "   ✓ Maintainer will handle final merge strategy"
		else
			echo "   ⚠ Using merge strategy (creates merge commit in feature branch)"
		fi
	fi
	echo ""

	if [[ "$force_push" == "false" ]]; then
		read -p "Continue? [Y/n]: " -n 1 -r
		echo
		if [[ $REPLY =~ ^[Nn]$ ]]; then
			echo "❌ Operation cancelled"
			return 0
		fi
	fi

	echo "🚀 Pushing feature branch to fork..."
	if [[ "$commits_ahead" == "new" ]]; then
		# First push
		if ! git push -u origin "$current_branch"; then
			echo "❌ Failed to push new branch"
			return 1
		fi
	else
		# Subsequent push - use force-with-lease for safety
		if ! git push origin "$current_branch" --force-with-lease; then
			echo "❌ Failed to push to origin. The branch may have been updated remotely."
			echo "   Try: git fetch origin && git rebase origin/$current_branch"
			return 1
		fi
	fi

	echo "✅ Feature branch $current_branch successfully pushed to fork"

	# Show PR URL if this looks like GitHub/GitLab
	local origin_url=$(git remote get-url origin 2>/dev/null)
	if [[ "$origin_url" =~ github\.com|gitlab\.com ]]; then
		local repo_path=$(echo "$origin_url" | sed -E 's/.*[:/]([^/]+\/[^/]+)(\.git)?$/\1/')
		if [[ "$origin_url" =~ github\.com ]]; then
			echo "🔗 PR URL: https://github.com/$repo_path/compare/$current_branch"
		elif [[ "$origin_url" =~ gitlab\.com ]]; then
			echo "🔗 MR URL: https://gitlab.com/$repo_path/-/merge_requests/new?merge_request[source_branch]=$current_branch"
		fi
	fi
}

# SSH wrapper to enable better Ghostty compatibility
# Disabled during development of new ssh-integration feature
# Remove once feature is merged upstream
#ssh() {
#  if [[ "$TERM" == "xterm-ghostty" ]]; then
#    TERM=xterm-256color command ssh "$@"
#  else
#    command ssh "$@"
#  fi
#}
