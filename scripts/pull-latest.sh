#!/usr/bin/env bash
#
# pull-latest.sh — Pull latest from actionit-dev (playground), branch dev-workspace.
# Run from repo root: ./scripts/pull-latest.sh
# Use before starting work or when you get errors (e.g. "Updates were rejected").
# Assumes: already authenticated, repo is actionit-dev (origin).
#

set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

REMOTE="origin"
BRANCH="dev-workspace"

echo "————————————————————————————————————————————————————————————"
echo "  Pull latest from playground (actionit-dev, branch: $BRANCH)"
echo "————————————————————————————————————————————————————————————"
echo ""

# Ensure we're on dev-workspace
CURRENT="$(git branch --show-current)"
if [ "$CURRENT" != "$BRANCH" ]; then
  echo "▶ Switching to branch '$BRANCH'..."
  git checkout "$BRANCH"
  echo ""
fi

echo "▶ Pulling from $REMOTE $BRANCH..."
if git pull "$REMOTE" "$BRANCH"; then
  echo ""
  echo "  Done. You have the latest from the playground."
else
  echo ""
  echo "  Pull failed (e.g. merge conflict). Fix the conflicts in the files Git names, then:"
  echo "    git add <resolved-files>"
  echo "    git commit -m \"Merge: resolve conflicts\""
  echo "  Then run ./scripts/push-to-playground.sh if you want to push."
  exit 1
fi

echo ""
echo "————————————————————————————————————————————————————————————"
