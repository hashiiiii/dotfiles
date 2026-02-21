#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

# Install mise version manager
install_mise() {
    if command -v mise &> /dev/null || [ -x "$HOME/.local/bin/mise" ]; then
        logInfo "mise is already installed."
        return 0
    fi
    logInfo "Installing mise..."
    curl https://mise.run | sh
    logOK "mise installation completed."
}

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
