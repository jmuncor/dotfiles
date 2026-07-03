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
    # RHEL-family only; anything else fails loudly.
    [ -r /etc/os-release ] && . /etc/os-release
    case " ${ID:-} ${ID_LIKE:-} " in
      *rhel* | *fedora* | *centos*)
        "$ROOT/script/bootstrap" rhel
        ;;
      *)
        printf 'Unsupported Linux distro: %s\n' "${ID:-unknown}" >&2
        exit 1
        ;;
    esac
    ;;
  *)
    printf 'Unsupported OS: %s\n' "$OS" >&2
    exit 1
    ;;
esac
