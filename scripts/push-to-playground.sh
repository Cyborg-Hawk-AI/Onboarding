#!/usr/bin/env bash
#
# push-to-playground.sh — Push to actionit-dev (playground), branch dev-workspace.
# Run from repo root: ./scripts/push-to-playground.sh
# Assumes: already authenticated (e.g. gh auth login), repo is actionit-dev (origin).
#
# What this does:
#  1. Ensures we're on branch dev-workspace (switches if not).
#  2. Pulls latest from origin dev-workspace (so we don't overwrite others).
#  3. Shows status; if uncommitted changes, offers to add/commit.
#  4. Pushes to origin dev-workspace.
# No force-push; only pushes to origin (actionit-dev). See docs/GIT_AND_CICD_STRATEGY.md
#

set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

REMOTE="origin"
BRANCH="dev-workspace"

echo "————————————————————————————————————————————————————————————"
echo "  Push to playground (actionit-dev, branch: $BRANCH)"
echo "————————————————————————————————————————————————————————————"
echo ""

# 1. Check current branch
CURRENT="$(git branch --show-current)"
if [ "$CURRENT" != "$BRANCH" ]; then
  echo "▶ You're on branch '$CURRENT'. We only push from '$BRANCH'."
  echo "  Switching to $BRANCH..."
  git checkout "$BRANCH"
  echo "  Done."
else
  echo "▶ Branch OK: you're on '$BRANCH'."
fi
echo ""

# 2. Pull latest (prevents overwriting others' work)
echo "▶ Pulling latest from $REMOTE/$BRANCH (so we don't overwrite anyone's changes)..."
if git pull "$REMOTE" "$BRANCH"; then
  echo "  Pull done."
else
  echo "  Pull had issues (e.g. merge conflict). Fix any conflicts, then run ./scripts/pull-latest.sh or this script again."
  exit 1
fi
echo ""

# 3. Status and optional commit
echo "▶ Current status:"
git status --short
echo ""

if ! git diff --quiet 2>/dev/null || ! git diff --staged --quiet 2>/dev/null; then
  echo "▶ You have uncommitted changes."
  read -r -p "  Add all and commit before pushing? (y/n) " DO_COMMIT
  if [ "$DO_COMMIT" = "y" ] || [ "$DO_COMMIT" = "Y" ]; then
    read -r -p "  Commit message (short description): " MSG
    if [ -z "$MSG" ]; then
      MSG="Update (push-to-playground.sh)"
    fi
    git add -A
    git commit -m "$MSG"
    echo "  Committed."
  else
    echo "  Skipping commit. Pushing existing commits only."
  fi
  echo ""
fi

# 4. Push to origin dev-workspace only (playground = actionit-dev)
echo "▶ Pushing to $REMOTE $BRANCH (playground; Vercel may deploy preview from here)..."
if git push "$REMOTE" "$BRANCH"; then
  echo ""
  echo "  Done. Your changes are on $REMOTE/$BRANCH (actionit-dev)."
else
  echo ""
  echo "  Push failed. If Git said 'rejected' or 'non-fast-forward', run:"
  echo "    ./scripts/pull-latest.sh"
  echo "  then fix any conflicts and run this script again."
  exit 1
fi

echo ""
echo "————————————————————————————————————————————————————————————"
