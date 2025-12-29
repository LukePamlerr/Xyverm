#!/usr/bin/env bash
set -euo pipefail

REMOTE_URL=${1-}
BRANCH=${2-main}
MSG=${3-'Initial Wyvem scaffold: backend, frontend, docs, SSO, migration tools'}

if ! command -v git >/dev/null 2>&1; then
  echo "git not found. Install git and re-run this script." >&2
  exit 1
fi

ROOT_DIR="$(pwd)"

if [ ! -d "$ROOT_DIR/.git" ]; then
  git init
  echo "Initialized git repository"
fi

if [ -n "$REMOTE_URL" ]; then
  if git remote get-url origin >/dev/null 2>&1; then
    git remote remove origin || true
  fi
  git remote add origin "$REMOTE_URL"
  echo "Remote 'origin' set to $REMOTE_URL"
fi

git add -A
git commit -m "$MSG" || echo "No changes to commit"

if [ -n "$REMOTE_URL" ]; then
  git push -u origin "$BRANCH"
else
  echo "No remote provided. To push, run: ./scripts/git_push.sh git@github.com:you/repo.git"
fi
