#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

# Install mise version manager
install_mise() {
    logInfo "Installing mise..."
    curl https://mise.run | sh
    logOK "mise installation completed."
}

# Install Homebrew if not present
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        logInfo "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH based on architecture
        if [[ "$(uname -m)" == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
        logOK "Homebrew installation completed."
    else
        logInfo "Homebrew already installed."
    fi
}
