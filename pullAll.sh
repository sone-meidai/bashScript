#!/bin/bash

# Set base directory
BASE_DIR="$HOME/Documents/Project"

# Create log directory
LOG_DIR="$HOME/git_pull_logs"
mkdir -p "$LOG_DIR"

echo "🔍 Searching for git repositories under $BASE_DIR"
echo "📝 Logs will be saved in: $LOG_DIR"
echo ""

# Collect git directories manually (macOS-safe)
git_dirs=()
while IFS= read -r line; do
    git_dirs+=("$line")
done < <(find "$BASE_DIR" -type d -name ".git")

# Loop through each Git repo
for gitdir in "${git_dirs[@]}"; do
    repo_dir="$(dirname "$gitdir")"
    repo_name="$(basename "$repo_dir")"
    timestamp="$(date +%Y-%m-%d_%H-%M-%S)"
    log_file="$LOG_DIR/${repo_name}_pull_${timestamp}.log"

    echo "========================================"
    echo "🔄 Pulling repository: $repo_name"
    echo "📁 Location: $repo_dir"
    echo "📄 Logging to: $log_file"
    echo "----------------------------------------"

    (
        cd "$repo_dir" || exit 1
        echo "[$(date)] Pulling in '$repo_name' at $repo_dir"
        git remote -v
        git branch --show-current
        git pull
    ) 2>&1 | tee "$log_file"

    echo ""
done

echo "✅ All repositories have been processed."
echo "📂 Detailed logs are saved in: $LOG_DIR"
