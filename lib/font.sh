#!/bin/bash

# Source logging utilities and configuration
source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/macos.conf"

# Use NERD_FONT from config, fallback to FiraCode if not set
DEFAULT_FONT=${NERD_FONT:-"FiraCode"}

install_nerd_fonts() {
    local font_name=${1:-$DEFAULT_FONT}
    local getnf_path="$HOME/.local/bin/getnf"
    local dotfiles_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    local nerd_fonts_cache="$dotfiles_cache/nerd-fonts"

    logInfo "Installing Nerd Font: $font_name using getnf"

    # Create cache directory
    mkdir -p "$nerd_fonts_cache"
    export GETNF_CACHE_DIR="$nerd_fonts_cache"

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
            logErr "Failed to install getnf"
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
            logErr "Font $font_name not found in available Nerd Fonts"
            logInfo "Available fonts can be listed with 'getnf -L'"
            return 1
        fi

        # Install the font using getnf
        logInfo "Installing $font_name font..."
        "$getnf_path" -i "$font_name"  # Always use user install

        # Verify installation
        if ! "$getnf_path" -l | grep -q "$font_name"; then
            logErr "Font installation may have failed. Please check 'getnf -l' for installed fonts."
            return 1
        fi
        logOK "Nerd Font installation completed successfully!"
    fi

    echo ""
    logImportant "=== Terminal Configuration Required ==="
    logImportant "Configure iTerm2:"
    logImportant "1. Open iTerm2 Preferences (Cmd+,)"
    logImportant "2. Go to 'Profiles' -> 'Text'"
    logImportant "3. Click 'Font' and select '${NERD_FONT} Nerd Font'"
    logImportant ""
    logImportant "Or configure Terminal.app:"
    logImportant "1. Open Terminal Preferences (Cmd+,)"
    logImportant "2. Go to 'Profiles'"
    logImportant "3. Select your profile"
    logImportant "4. Click 'Text' tab"
    logImportant "5. Click 'Change...' next to font"
    logImportant "6. Select '${NERD_FONT} Nerd Font'"
    logImportant "=========================================="
    echo ""

    return 0
}

# If script is run directly (not sourced), install the default font
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    install_nerd_fonts "$@"
fi
