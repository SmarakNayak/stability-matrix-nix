#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NIX="$(dirname "$0")/../package.nix"

current_version() {
  grep 'version = ' "$PACKAGE_NIX" | head -1 | sed 's/.*version = "\(.*\)".*/\1/'
}

latest_version() {
  curl -sf https://api.github.com/repos/LykosAI/StabilityMatrix/releases/latest \
    | grep '"tag_name"' \
    | sed 's/.*"v\(.*\)".*/\1/'
}

fetch_hash() {
  local version="$1"
  local url="https://github.com/LykosAI/StabilityMatrix/releases/download/v${version}/StabilityMatrix-linux-x64.zip"
  local tmpdir
  tmpdir=$(mktemp -d)
  curl -sL "$url" -o "$tmpdir/file.zip"
  unzip -q "$tmpdir/file.zip" -d "$tmpdir/unpacked"
  nix hash path --sri --type sha256 "$tmpdir/unpacked"
  rm -rf "$tmpdir"
}

CURRENT=$(current_version)
LATEST=$(latest_version)

echo "Current: $CURRENT"
echo "Latest:  $LATEST"

if [ "$CURRENT" = "$LATEST" ]; then
  echo "Already up to date."
  echo "updated=false" >> "${GITHUB_OUTPUT:-/dev/null}"
  exit 0
fi

echo "Updating $CURRENT -> $LATEST"
HASH=$(fetch_hash "$LATEST")
echo "Hash: $HASH"

sed -i "s|version = \"${CURRENT}\"|version = \"${LATEST}\"|" "$PACKAGE_NIX"
sed -i "s|hash = \"sha256-.*\"|hash = \"${HASH}\"|" "$PACKAGE_NIX"

echo "updated=true" >> "${GITHUB_OUTPUT:-/dev/null}"
echo "version=$LATEST" >> "${GITHUB_OUTPUT:-/dev/null}"
