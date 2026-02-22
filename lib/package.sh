#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

# Install Homebrew if not present
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        logInfo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        eval "$(/opt/homebrew/bin/brew shellenv)"
        logOK "Homebrew installation completed."
    else
        logInfo "Homebrew already installed."
    fi
}
