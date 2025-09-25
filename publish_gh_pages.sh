#!/bin/bash
# Helper to publish the gh-pages/ directory to the gh-pages branch.
# Usage: ./publish_gh_pages.sh
set -euo pipefail

if [ ! -d gh-pages ]; then
  echo "gh-pages directory not found. Build first with ./build.sh"
  exit 1
fi

BRANCH=gh-pages
TMPDIR=$(mktemp -d)

echo "Publishing gh-pages -> ${BRANCH} branch"

git worktree add -B ${BRANCH} ${TMPDIR} origin/${BRANCH} 2>/dev/null || git worktree add -B ${BRANCH} ${TMPDIR}

# Copy files	rm -rf ${TMPDIR}/*
cp -r gh-pages/* ${TMPDIR}/

pushd ${TMPDIR}
if [ -z "$(git status --porcelain)" ]; then
  echo "No changes to publish"
else
  git add --all
  git commit -m "Publish RPMs to gh-pages"
  git push origin ${BRANCH}
fi
popd

git worktree remove ${TMPDIR}
rm -rf ${TMPDIR}

echo "Published gh-pages."