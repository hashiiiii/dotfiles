#!/bin/bash
set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running common.sh...'

if ! command -v brew >/dev/null 2>&1; then
  logInfo "Homebrew not found. Starting installation..."

  # Run Homebrew's installation script
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Configure Homebrew environment variables depending on the operating system
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # For Linux systems
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  else
    # For macOS: use the appropriate path depending on the architecture
    if [ -d "/opt/homebrew" ]; then
      # For Apple Silicon (M1/M2)
      eval "$(/opt/homebrew/bin/brew shellenv)"
    else
      # For Intel macs
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  logOK "Homebrew installation completed."
else
  logInfo "Homebrew is already installed."
fi

# If a .Brewfile exists, install the Homebrew packages listed in it using brew bundle
BREWFILE="$DOTFILE_HOME/.Brewfile"
if [ -f "$BREWFILE" ]; then
  logInfo "Installing Homebrew packages from .Brewfile..."
  brew bundle --file="$BREWFILE"
  logOK "Homebrew packages installation completed."
else
  logWarn ".Brewfile not found at $BREWFILE."
fi
