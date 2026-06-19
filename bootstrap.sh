#!/bin/sh
# POSIX sh only — no bashisms; runs on stock macOS before anything is installed.
set -eu

REPO_URL="${REPO_URL:-https://github.com/hashiiiii/dotfiles.git}"
DOTFILE_DIR="${DOTFILE_DIR:-$HOME/workspace/dotfiles}"

info() { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$1"; }
die()  { printf '\033[1;31m[bootstrap] error:\033[0m %s\n' "$1" >&2; exit 1; }

[ "$(uname -s)" = "Darwin" ] || die "macOS only."
[ "$(id -u)" -ne 0 ]        || die "Do not run as root."

xcode-select -p >/dev/null 2>&1 \
  || die "Xcode Command Line Tools required. Run: xcode-select --install"

if ! command -v brew >/dev/null 2>&1; then
  info "Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

if ! command -v mise >/dev/null 2>&1; then
  info "Installing mise..."
  brew install mise
fi

if [ -d "$DOTFILE_DIR/.git" ]; then
  info "Updating $DOTFILE_DIR..."
  git -C "$DOTFILE_DIR" pull --ff-only || info "Skipped pull (local changes or diverged branch)."
else
  info "Cloning into $DOTFILE_DIR..."
  mkdir -p "$(dirname "$DOTFILE_DIR")"
  git clone "$REPO_URL" "$DOTFILE_DIR"
fi

# Pre-apply dotfiles so the global ~/.config/mise/config.toml ([tools]) is in place before
# `mise bootstrap` resolves tools on a first-ever run. Cheap + idempotent — keep it.
cd "$DOTFILE_DIR"
info "Trusting mise config..."
mise trust
info "Applying dotfiles..."
mise dotfiles apply --yes
info "Running mise bootstrap..."
mise bootstrap --yes

info "Done. Restart your terminal (login shell is now zsh)."
