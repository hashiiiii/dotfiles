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

if [[ "$OS" == "Darwin" ]]; then
  logOK "MacOS is detected."
  "$DOTFILE_HOME/scripts/macosx.sh"
else
  logErr "Unsupported OS: $OS. This dotfiles system only supports macOS."
  exit 1
fi
