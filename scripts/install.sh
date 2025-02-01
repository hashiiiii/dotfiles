#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"

logInfo 'Running install.sh...'

OS=$(uname -s)

if [[ "$OS" == "Linux" ]]; then
  source /etc/os-release

  if [ "$ID" = "debian" ] || echo "$ID_LIKE" | grep -q "debian"; then
    logOK 'Debian is detected.'
    "$DOTFILE_HOME/scripts/debian.sh"
  else
    logErr "Other Linux distribution: $ID"
    exit 1
  fi
elif [[ "$OS" == "Darwin" ]]; then
  logOK "MacOSX is detected."
  # ./install-mac.sh
else
  logErr "Unsupported OS: $OS"
  exit 1
fi
