#!/bin/bash

# Source logging utilities and configuration
source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

# Use NERD_FONT from config, fallback to FiraCode if not set
DEFAULT_FONT=${NERD_FONT:-"FiraCode"}

install_nerd_fonts() {
    local font_name=${1:-$DEFAULT_FONT}
    local os_type=$(uname)

    logInfo "Installing Nerd Font: $font_name using getnf"

    # Check if getnf is installed
    if ! command -v getnf &> /dev/null; then
        logInfo "Installing getnf..."
        curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    fi

    # Check if font is already installed
    if getnf -l | grep -q "$font_name"; then
        logInfo "Font $font_name is already installed. Checking for updates..."
        getnf -U
        logOK "Font check and update completed."
        return 0
    fi

    # Verify font exists in available fonts
    if ! getnf -L | grep -q "$font_name"; then
        logError "Font $font_name not found in available Nerd Fonts"
        logInfo "Available fonts can be listed with 'getnf -L'"
        return 1
    fi

    # Install the font using getnf
    logInfo "Installing $font_name font..."
    if [[ -d "/mnt/c/Windows" ]]; then
        # WSL2 environment - install for all users
        getnf -gi "$font_name"
    else
        # macOS or Linux - install for current user
        getnf -i "$font_name"
    fi

    # Verify installation
    if getnf -l | grep -q "$font_name"; then
        logOK "Nerd Font installation completed successfully!"
    else
        logError "Font installation may have failed. Please check 'getnf -l' for installed fonts."
        return 1
    fi
    
    # Show additional instructions for WSL2
    if [[ -d "/mnt/c/Windows" ]]; then
        logInfo "Note: You may need to restart Windows applications to use the new fonts"
    fi
}

# If script is run directly (not sourced), install the default font
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_nerd_fonts "$@"
fi
