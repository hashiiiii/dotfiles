#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running common.sh...'

logInfo "Installing Homebrew..."
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

BREWFILE="$DOTFILE_HOME/.Brewfile"

if [ -f "$BREWFILE" ]; then
  logInfo "Installing Homebrew packages from .Brewfile..."
  brew bundle --file="$BREWFILE"
  logOK "Homebrew packages installation completed."
else
  logErr ".Brewfile not found at $BREWFILE."
  exit 1
fi

logInfo "Installing mise..."
curl https://mise.run | sh
logOK "mise installation completed."
