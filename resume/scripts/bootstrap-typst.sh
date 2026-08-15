#!/usr/bin/env bash
set -euo pipefail

VERSION="${1:-0.15.1}"
DEST_DIR="${2:-.tools/bin}"
DEST="$DEST_DIR/typst"

if [[ -x "$DEST" ]]; then
  "$DEST" --version
  exit 0
fi

OS="$(uname -s)"
ARCH="$(uname -m)"

case "$OS/$ARCH" in
  Linux/x86_64|Linux/amd64)
    TARGET="x86_64-unknown-linux-musl"
    ;;
  Linux/aarch64|Linux/arm64)
    TARGET="aarch64-unknown-linux-musl"
    ;;
  Darwin/arm64|Darwin/aarch64)
    TARGET="aarch64-apple-darwin"
    ;;
  Darwin/x86_64|Darwin/amd64)
    TARGET="x86_64-apple-darwin"
    ;;
  *)
    echo "Unsupported platform: $OS/$ARCH" >&2
    echo "Install Typst manually and run: make TYPST=typst site" >&2
    exit 1
    ;;
esac

ARCHIVE="typst-${TARGET}.tar.xz"
URL="https://github.com/typst/typst/releases/download/v${VERSION}/${ARCHIVE}"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

mkdir -p "$DEST_DIR"
echo "Downloading Typst ${VERSION} for ${TARGET}..."
curl --fail --location --silent --show-error --retry 3 --retry-delay 1 \
  "$URL" -o "$TMP/$ARCHIVE"

tar -xJf "$TMP/$ARCHIVE" -C "$TMP"
BIN="$(find "$TMP" -type f -name typst -perm -u+x | head -n 1)"
if [[ -z "$BIN" ]]; then
  echo "Could not find Typst binary after extracting $ARCHIVE" >&2
  exit 1
fi

cp "$BIN" "$DEST"
chmod 0755 "$DEST"
"$DEST" --version
