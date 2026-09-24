#!/usr/bin/env bash
# Entrypoint for a fresh machine: work out which bootstrap target this OS is
# and hand off to script/bootstrap. macOS and RHEL-family Linux only; anything
# else fails loudly instead of half-installing.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=script/lib.sh
. "$ROOT/script/lib.sh"

OS="$(uname -s)"

case "$OS" in
  Darwin)
    TARGET=macos
    ;;
  Linux)
    [ -r /etc/os-release ] && . /etc/os-release
    case " ${ID:-} ${ID_LIKE:-} " in
      *rhel* | *fedora* | *centos*) TARGET=rhel ;;
      *) die "Unsupported Linux distro: ${ID:-unknown}" ;;
    esac
    ;;
  *)
    die "Unsupported OS: $OS"
    ;;
esac

exec "$ROOT/script/bootstrap" "$TARGET"
