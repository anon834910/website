# Backup your current branch name
current_branch=$(git rev-parse --abbrev-ref HEAD)

# Create a new orphan branch (no history)
git checkout --orphan temp_branch

# Add all files to the new branch
git add -A

# Create a new commit
git commit -m "Initial commit"

# Delete the original branch
git branch -D $current_branch

# Rename temp branch to original branch name
git branch -m $current_branch

# Force push to remote repository
git push -f origin $current_branch

# Clean up any lingering files
git gc --aggressive --prune=all
