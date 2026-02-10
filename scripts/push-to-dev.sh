#!/usr/bin/env bash
#
# push-to-dev.sh — Dummy-proof push to axnt-dev-workspace (dev-workspace branch).
# Run from repo root: ./scripts/push-to-dev.sh
#
# What this does:
#  1. Ensures we're on branch dev-workspace (switches if not).
#  2. Pulls latest from axnt-dev dev-workspace (so we don't overwrite others).
#  3. Shows status; if there are uncommitted changes, offers to add/commit.
#  4. Pushes to axnt-dev dev-workspace.
# No force-push, no pushing to origin. See docs/GIT_AND_CICD_STRATEGY.md
#

set -e
REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

REMOTE="axnt-dev"
BRANCH="dev-workspace"

echo "————————————————————————————————————————————————————————————"
echo "  Push to dev (axnt-dev-workspace, branch: $BRANCH)"
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
  echo "  Pull had issues (e.g. merge conflict). Fix any conflicts, then run this script again."
  exit 1
fi
echo ""

# 3. Status and optional commit
echo "▶ Current status:"
git status --short
echo ""

if ! git diff --quiet || ! git diff --staged --quiet 2>/dev/null; then
  echo "▶ You have uncommitted changes."
  read -r -p "  Add all and commit before pushing? (y/n) " DO_COMMIT
  if [ "$DO_COMMIT" = "y" ] || [ "$DO_COMMIT" = "Y" ]; then
    read -r -p "  Commit message (short description): " MSG
    if [ -z "$MSG" ]; then
      MSG="Update (push-to-dev.sh)"
    fi
    git add -A
    git commit -m "$MSG"
    echo "  Committed."
  else
    echo "  Skipping commit. Pushing existing commits only."
  fi
  echo ""
fi

# 4. Push to axnt-dev dev-workspace only
echo "▶ Pushing to $REMOTE $BRANCH (this updates the dev playground; Vercel may deploy from here)..."
if git push "$REMOTE" "$BRANCH"; then
  echo ""
  echo "  Done. Your changes are on $REMOTE/$BRANCH."
else
  echo ""
  echo "  Push failed. If Git said 'rejected' or 'non-fast-forward', run:"
  echo "    git pull $REMOTE $BRANCH"
  echo "  then fix any conflicts and run this script again."
  exit 1
fi

echo ""
echo "————————————————————————————————————————————————————————————"
