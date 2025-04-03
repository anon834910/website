#!/bin/bash
# scrub_git_history.sh
# This script rewrites the commit history to replace commit names/emails with anonymous values,
# then force pushes the updated branch.
# WARNING: Make sure you have a backup before running this script.

# Set your anonymous details
ANON_NAME="anonymous"
ANON_EMAIL="anon@example.com"

# Specify branch to update (change "master" to your branch if necessary)
BRANCH="main"

# Use git-filter-repo if available, else fall back to git-filter-branch
if command -v git-filter-repo &> /dev/null; then
    echo "Using git-filter-repo to scrub commit history..."
    git filter-repo --commit-callback '
commit.author_name = b"'${ANON_NAME}'"
commit.author_email = b"'${ANON_EMAIL}'"
commit.committer_name = b"'${ANON_NAME}'"
commit.committer_email = b"'${ANON_EMAIL}'"
'
else
    echo "git-filter-repo not found. Falling back to git-filter-branch..."
    git filter-branch --env-filter '
export GIT_AUTHOR_NAME="'"$ANON_NAME"'"
export GIT_AUTHOR_EMAIL="'"$ANON_EMAIL"'"
export GIT_COMMITTER_NAME="'"$ANON_NAME"'"
export GIT_COMMITTER_EMAIL="'"$ANON_EMAIL"'"
' -- --all
fi

# Force push the rewritten history to the remote repository
echo "Force pushing changes to remote branch ${BRANCH}..."
git push origin ${BRANCH} --force

echo "Scrubbing complete. Verify your repository."

