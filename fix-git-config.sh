#!/usr/bin/env bash

# This script fixes the git configuration in the build submodule
# to ensure Docker builds can access git commands during Crystal compilation

echo "Fixing git configuration for Docker build..."

cd "$(dirname "$0")/build" || exit 1

if [ -f ".git" ]; then
  echo "Found git worktree marker file, copying git history..."

  rm .git

  if [ -d "../.git/modules/build" ]; then
    cp -r "../.git/modules/build" .git
    echo "Copied git history from parent repository"
  else
    echo "Error: Could not find git history at ../.git/modules/build"
    echo "You may need to reinitialize the submodule:"
    echo "  cd .. && git submodule update --init --recursive"
    exit 1
  fi
fi

if [ -f ".git/config" ]; then
  if grep -q "worktree" .git/config; then
    echo "Removing problematic worktree configuration..."
    sed -i '/worktree/d' .git/config
    echo "Fixed git configuration"
  fi
fi

if git rev-list HEAD --max-count=1 --abbrev-commit >/dev/null 2>&1; then
  echo "✓ Git configuration is working correctly"
  echo "✓ Current commit: $(git rev-list HEAD --max-count=1 --abbrev-commit)"
else
  echo "✗ Git configuration is still broken"
  exit 1
fi

echo "Git configuration fix completed successfully!"

