#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running common.sh...'

BREWFILE="$DOTFILE_HOME/.Brewfile"

if [ -f "$BREWFILE" ]; then
  logInfo "Installing Homebrew packages from .Brewfile..."
  brew bundle --file="$BREWFILE"
  logOK "Homebrew packages installation completed."
else
  logErr ".Brewfile not found at $BREWFILE."
  exit 1
fi
