#!/usr/bin/env bash
set -eo pipefail

# Configuration
REPO="APTITUDE-Consortium/aptitude-eudi-wallet-specs"
TARGET_DIR="temp_remote_assets"

# Build clone URL
if command -v gh &> /dev/null && gh auth status &> /dev/null; then
  TOKEN=$(gh auth token | tr -d '\r\n')
  CLONE_URL="https://x-access-token:${TOKEN}@github.com/${REPO}.git"
else
  CLONE_URL="https://github.com/${REPO}.git"
fi

rm -rf "$TARGET_DIR"

# Ensure cleanup on unexpected exit
trap 'rm -rf "$TARGET_DIR"' EXIT

# Clone remote repository with --no-checkout
git clone \
  --filter=blob:none \
  --no-checkout \
  --depth=1 \
  "$CLONE_URL" \
  "$TARGET_DIR"

# Enable sparse checkout and populate files inside temp directory
pushd "$TARGET_DIR" > /dev/null

git sparse-checkout init --no-cone
git sparse-checkout set \
  "docs/glossary-definitions.md" \
  "docs/img/eu-cofunded.png" \
  "docs/media/*" \
  "docs/overrides/*"

popd > /dev/null

# Merge assets into local project workspace
mkdir -p docs/img docs/media docs/overrides
cp -r "$TARGET_DIR/docs/"* ./docs/

echo "Successfully merged remote assets!"