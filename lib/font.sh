#!/bin/bash

# Source logging utilities and configuration
source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

# Use NERD_FONT from config, fallback to FiraCode if not set
DEFAULT_FONT=${NERD_FONT:-"FiraCode"}

install_nerd_fonts() {
    local font_name=${1:-$DEFAULT_FONT}
    local os_type=$(uname)
    local getnf_path="$HOME/.local/bin/getnf"

    logInfo "Installing Nerd Font: $font_name using getnf"

    # Check if getnf is installed
    if ! command -v getnf &> /dev/null && [ ! -x "$getnf_path" ]; then
        logInfo "Installing getnf..."
        curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash
    fi

    # Use direct path to getnf if it's not in PATH
    if ! command -v getnf &> /dev/null; then
        if [ -x "$getnf_path" ]; then
            alias getnf="$getnf_path"
        else
            logError "Failed to install getnf"
            return 1
        fi
    fi

    # Check if font is already installed
    if "$getnf_path" -l | grep -q "$font_name"; then
        logInfo "Font $font_name is already installed. Checking for updates..."
        "$getnf_path" -U
        logOK "Font check and update completed."
    else
        # Verify font exists in available fonts
        if ! "$getnf_path" -L | grep -q "$font_name"; then
            logError "Font $font_name not found in available Nerd Fonts"
            logInfo "Available fonts can be listed with 'getnf -L'"
            return 1
        fi

        # Install the font using getnf
        logInfo "Installing $font_name font..."
        if [[ -d "/mnt/c/Windows" ]]; then
            # WSL2 environment - install for all users
            "$getnf_path" -gi "$font_name"
        else
            # macOS or Linux - install for current user
            "$getnf_path" -i "$font_name"
        fi

        # Verify installation
        if ! "$getnf_path" -l | grep -q "$font_name"; then
            logError "Font installation may have failed. Please check 'getnf -l' for installed fonts."
            return 1
        fi
        logOK "Nerd Font installation completed successfully!"
    fi

    # Show additional instructions for WSL2
    if [[ -d "/mnt/c/Windows" ]]; then
        echo ""
        logImportant "=== Windows Font Installation Required ==="
        logImportant "Please run the following command in PowerShell (as Administrator):"
        logImportant "Start-Process pwsh -Verb RunAs -ArgumentList '-ExecutionPolicy Bypass -File \"\\\\wsl\$\\Debian$DOTFILE_HOME/lib/Install-NerdFonts.ps1\"'"
        logImportant "Or install manually using Scoop:"
        logImportant "1. scoop bucket add nerd-fonts"
        logImportant "2. scoop install ${NERD_FONT}-NF"
        logImportant ""
        logImportant "After installation, set up Windows Terminal:"
        logImportant "1. Open Windows Terminal"
        logImportant "2. Press Ctrl+Shift+, to open settings"
        logImportant "3. Click on your profile (e.g., Ubuntu)"
        logImportant "4. Go to 'Additional Settings' -> 'Appearance'"
        logImportant "5. Change 'Font face' to '${NERD_FONT} NF'"
        logImportant "6. Click 'Save'"
        logImportant "=========================================="
        echo ""
    fi
    
    return 0
}

# If script is run directly (not sourced), install the default font
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_nerd_fonts "$@"
fi
