#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/package.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running common.sh...'

# Install packages from Brewfile
install_brew_packages "$DOTFILE_HOME/.Brewfile"

# Install mise version manager
install_mise
