#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
CONFIG_NAME="${DOTFILES_DARWIN_CONFIG:-default}"

DRY_RUN=0
YES=0
INSTALL_NIX=1
LINK_DOTFILES=1
APPLY_DARWIN=1

usage() {
  cat <<'USAGE'
Usage: bootstrap.sh [options]

Set up this macOS machine from the dotfiles repository.

Options:
  --config <name>       nix-darwin flake configuration name
  --dry-run             Print commands without running them
  --yes                 Do not prompt before installing Nix
  --skip-nix-install    Fail if Nix is not already installed
  --skip-link           Skip dotfile symlink installation
  --skip-darwin         Skip nix-darwin switch
  -h, --help            Show this help
USAGE
}

log() {
  printf '[bootstrap] %s\n' "$*"
}

die() {
  printf '[bootstrap] error: %s\n' "$*" >&2
  exit 1
}

quote_command() {
  printf '%q ' "$@"
  printf '\n'
}

run() {
  if [ "$DRY_RUN" -eq 1 ]; then
    printf '[dry-run] '
    quote_command "$@"
    return
  fi

  "$@"
}

confirm() {
  if [ "$YES" -eq 1 ]; then
    return
  fi

  if [ ! -t 0 ]; then
    die "$1 Pass --yes to run non-interactively."
  fi

  printf '%s [y/N] ' "$1"
  read -r answer
  case "$answer" in
    y|Y|yes|YES)
      ;;
    *)
      die "aborted"
      ;;
  esac
}

find_nix() {
  if command -v nix >/dev/null 2>&1; then
    command -v nix
    return
  fi

  if [ -x /nix/var/nix/profiles/default/bin/nix ]; then
    printf '%s\n' /nix/var/nix/profiles/default/bin/nix
    return
  fi

  return 1
}

load_nix_profile() {
  if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
    # shellcheck disable=SC1091
    . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
  fi
}

ensure_macos() {
  if [ "$(uname -s)" != "Darwin" ]; then
    die "this bootstrap script currently supports macOS only"
  fi
}

ensure_required_flake_files_are_tracked() {
  if ! git -C "$DOTFILES_DIR" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    return
  fi

  local untracked
  untracked="$(git -C "$DOTFILES_DIR" ls-files --others --exclude-standard -- flake.nix nix 2>/dev/null || true)"
  if [ -n "$untracked" ]; then
    printf '%s\n' "$untracked" >&2
    if [ "$DRY_RUN" -eq 1 ]; then
      log "warning: Nix flakes ignore untracked files in Git repositories"
      return
    fi
    die "Nix flakes ignore untracked files in Git repositories. Track these files before running bootstrap."
  fi
}

install_nix_if_needed() {
  if find_nix >/dev/null 2>&1; then
    log "Nix is already installed"
    return
  fi

  if [ "$INSTALL_NIX" -eq 0 ]; then
    die "Nix is not installed"
  fi

  confirm "Nix is not installed. Install Determinate Nix now?"

  local installer_url="https://install.determinate.systems/nix"
  local tmpdir
  tmpdir="$(mktemp -d)"
  trap 'rm -rf "$tmpdir"' EXIT

  log "downloading Determinate Nix installer"
  run curl --proto '=https' --tlsv1.2 -sSf -L "$installer_url" -o "$tmpdir/install-nix"

  log "installing Determinate Nix"
  run sh "$tmpdir/install-nix" install --no-confirm

  if [ "$DRY_RUN" -eq 1 ]; then
    return
  fi

  load_nix_profile
  find_nix >/dev/null 2>&1 || die "Nix install finished, but nix is still not available"
}

link_dotfiles() {
  if [ "$LINK_DOTFILES" -eq 0 ]; then
    return
  fi

  log "linking dotfiles"
  run bash "$DOTFILES_DIR/.bin/install.sh"
}

switch_darwin() {
  if [ "$APPLY_DARWIN" -eq 0 ]; then
    return
  fi

  ensure_required_flake_files_are_tracked

  local nix_cmd
  if ! nix_cmd="$(find_nix)"; then
    if [ "$DRY_RUN" -eq 1 ]; then
      nix_cmd="nix"
    else
      die "nix command not found"
    fi
  fi

  local flake_ref="$DOTFILES_DIR#$CONFIG_NAME"
  local sudo_cmd=()
  if [ "${EUID:-$(id -u)}" -ne 0 ]; then
    sudo_cmd=(sudo)
  fi

  if command -v darwin-rebuild >/dev/null 2>&1; then
    log "applying nix-darwin configuration: $CONFIG_NAME"
    run "${sudo_cmd[@]}" darwin-rebuild switch --flake "$flake_ref"
    return
  fi

  log "applying nix-darwin configuration with nix run: $CONFIG_NAME"
  run "${sudo_cmd[@]}" "$nix_cmd" run github:nix-darwin/nix-darwin/master#darwin-rebuild -- switch --flake "$flake_ref"
}

while [ "$#" -gt 0 ]; do
  case "$1" in
    --config)
      [ "$#" -ge 2 ] || die "--config requires a value"
      CONFIG_NAME="$2"
      shift
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    --yes)
      YES=1
      ;;
    --skip-nix-install)
      INSTALL_NIX=0
      ;;
    --skip-link)
      LINK_DOTFILES=0
      ;;
    --skip-darwin)
      APPLY_DARWIN=0
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      die "unknown option: $1"
      ;;
  esac
  shift
done

ensure_macos
install_nix_if_needed
link_dotfiles
switch_darwin

log "done"
