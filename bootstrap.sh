#!/bin/sh
# One-line bootstrap entry for this dotfiles repo.
#
#   curl -fsSL https://raw.githubusercontent.com/hashiiiii/dotfiles/main/bootstrap.sh | sh
#
# Keeps only the minimum imperative steps (Homebrew + mise); everything else
# (packages, dotfiles, macOS defaults, login shell, runtimes) is declared in
# mise.toml and applied by `mise bootstrap`.
#
# POSIX sh only — must run on a stock macOS shell with nothing preinstalled.
# No bashisms: no [[ ]], arrays, `local`, or `set -o pipefail`.
set -eu

REPO_URL="${REPO_URL:-https://github.com/hashiiiii/dotfiles.git}"
DOTFILE_DIR="${DOTFILE_DIR:-$HOME/workspace/dotfiles}"

info() { printf '\033[1;34m[bootstrap]\033[0m %s\n' "$1"; }
die()  { printf '\033[1;31m[bootstrap] error:\033[0m %s\n' "$1" >&2; exit 1; }

# 1. Sanity checks
[ "$(uname -s)" = "Darwin" ] || die "macOS only."
[ "$(id -u)" -ne 0 ]        || die "Do not run as root."

# 2. Xcode Command Line Tools (provides git and curl)
xcode-select -p >/dev/null 2>&1 \
  || die "Xcode Command Line Tools required. Run: xcode-select --install"

# 3. Homebrew — the package manager for everything in the Brewfile
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

# 4. mise — drives the declarative bootstrap below
if ! command -v mise >/dev/null 2>&1; then
  info "Installing mise..."
  brew install mise
fi

# 5. Clone or update this repo
if [ -d "$DOTFILE_DIR/.git" ]; then
  info "Updating $DOTFILE_DIR..."
  git -C "$DOTFILE_DIR" pull --ff-only || info "Skipped pull (local changes or diverged branch)."
else
  info "Cloning into $DOTFILE_DIR..."
  mkdir -p "$(dirname "$DOTFILE_DIR")"
  git clone "$REPO_URL" "$DOTFILE_DIR"
fi

# 6. Hand off to mise.
#    Apply dotfiles FIRST so the global mise config (~/.config/mise/config.toml,
#    symlinked from this repo and declaring [tools]) is in place before the
#    bootstrap tools step runs in a fresh process. Then converge everything.
cd "$DOTFILE_DIR"
info "Trusting mise config..."
mise trust
info "Applying dotfiles..."
mise dotfiles apply --yes
info "Running mise bootstrap..."
mise bootstrap --yes

info "Done. Restart your terminal (login shell is now zsh)."
