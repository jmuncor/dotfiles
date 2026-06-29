#!/usr/bin/env bash

if [ -z "${BASH_VERSION:-}" ]; then
  exec bash "$0" "$@"
fi

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"

case "$OS" in
  Darwin)
    "$ROOT/script/bootstrap" macos
    ;;
  Linux)
    "$ROOT/script/bootstrap" ubuntu
    ;;
  *)
    printf 'Unsupported OS: %s\n' "$OS" >&2
    exit 1
    ;;
esac
