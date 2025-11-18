#!/bin/bash
set -e

# Usage check
if [ $# -ne 2 ]; then
  echo "Usage: $0 <version> <directory>"
  exit 1
fi

VERSION="$1"
DIR="$2"
TAG="v$VERSION"
TITLE="$(date +%Y-%m-%d), Version $VERSION"

# Find files in the specified directory
FILES=("$DIR"/"$VERSION"*)
if [ ${#FILES[@]} -eq 0 ]; then
  echo "No files found in $DIR starting with $VERSION"
  exit 1
fi

echo "Files to upload: ${FILES[@]}"

# Create release with GitHub CLI
gh release create "$TAG" "${FILES[@]}" \
  --title "$TITLE" \
  --notes "" \
  --draft=false \
  --prerelease=false

echo "Release $TAG created successfully!"

# Append version to released.txt
echo "$VERSION" >> released.txt

# Commit and push the update
git add released.txt
git commit -m "[Automated] Updated released.txt"
git push

echo "released.txt updated and changes pushed."