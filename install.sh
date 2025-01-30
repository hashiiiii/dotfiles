#!/bin/bash

set -e

DOTFILE_HOME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILE_HOME

source "$DOTFILE_HOME/lib/log.sh"

OS=$(uname -s)

if [[ "$OS" == "Linux" ]]; then
  if grep -q WSL /proc/version; then
    logOK "WSL is detected."
    # ./install-wsl.sh
  else
    logErr "Linux is detected, but currently, only WSL is supported."
    exit 1
  fi
elif [[ "$OS" == "Darwin" ]]; then
  logOK "MacOSX is detected."
  # ./install-mac.sh
else
  logErr "Unsupported OS: $OS"
  exit 1
fi
