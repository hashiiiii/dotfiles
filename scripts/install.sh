#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"

# Prevent running as root for security
if [ "$(id -u)" -eq 0 ]; then
  logErr "Please do not run this script as root. Run it as a regular user."
  exit 1
fi

logInfo 'Running install.sh...'

# Detect operating system
OS=$(uname -s)

# Install packages based on OS type
if [[ "$OS" == "Linux" ]]; then
  # For Linux, check if it's Debian-based
  source /etc/os-release
  if [ "$ID" = "debian" ] || echo "$ID_LIKE" | grep -qi "debian"; then
    logOK 'Debian-based system is detected.'
    "$DOTFILE_HOME/scripts/debian.sh"
  else
    logErr "Unsupported Linux distribution: $ID"
    exit 1
  fi
elif [[ "$OS" == "Darwin" ]]; then
  logOK "MacOS is detected."
  "$DOTFILE_HOME/scripts/macosx.sh"
else
  logErr "Unsupported OS: $OS"
  exit 1
fi
