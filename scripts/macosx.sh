#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/common.sh"
source "$DOTFILE_HOME/macos.conf"

logInfo 'Running macosx.sh...'

############################################
# System Requirements Check
############################################

check_system_requirements "$DOTFILE_HOME/macos.conf" || exit 1

# macOS-specific system checks
check_macos_requirements() {
    # System Integrity Protection check
    if ! csrutil status | grep -q 'disabled'; then
        logWarn "System Integrity Protection is enabled. Some features might be restricted."
    fi

    # Check if Xcode Command Line Tools are installed
    if ! xcode-select -p &> /dev/null; then
        logInfo "Installing Xcode Command Line Tools..."
        xcode-select --install
        until xcode-select -p &> /dev/null; do
            sleep 1
        done
        logOK "Xcode Command Line Tools installation completed."
    else
        logInfo "Xcode Command Line Tools already installed."
    fi

    # Install Rosetta 2 if on Apple Silicon
    if [[ "$(uname -m)" == "arm64" ]]; then
        logInfo "Apple Silicon detected, installing Rosetta 2..."
        if ! pkgutil --pkg-info com.apple.pkg.RosettaUpdateAuto > /dev/null 2>&1; then
            if ! softwareupdate --install-rosetta --agree-to-license; then
                logWarn "Failed to install Rosetta 2"
            else
                logOK "Rosetta 2 installation completed."
            fi
        else
            logInfo "Rosetta 2 already installed."
        fi
    fi
}

check_macos_requirements

############################################
# Package Management
############################################

# Install and configure Homebrew
install_homebrew || { logErr "Failed to install Homebrew"; exit 1; }

# Install Homebrew taps
install_brew_taps() {
    validate_config "Homebrew taps" "${BREW_TAPS[@]}" || return 0
    
    local -a failed_taps=()
    for tap in "${BREW_TAPS[@]}"; do
        if ! brew tap | grep -q "$tap"; then
            logInfo "Adding tap: $tap..."
            if ! brew tap "$tap"; then
                failed_taps+=("$tap")
                logWarn "Failed to add tap: $tap"
            fi
        else
            logInfo "Tap $tap already added."
        fi
    done
    
    [[ ${#failed_taps[@]} -gt 0 ]] && logWarn "Failed taps: ${failed_taps[*]}"
}

install_brew_taps

# Install packages and casks using refactored function
validate_config "Homebrew packages" "${BREW_PACKAGES[@]}" && {
    install_packages "brew" "${BREW_PACKAGES[@]}"
}

validate_config "Homebrew casks" "${BREW_CASKS[@]}" && {
    install_packages "brew-cask" "${BREW_CASKS[@]}"
}

# Install Mac App Store applications
install_mas_apps() {
    if ! _command_exists mas; then
        logWarn "mas not available, skipping Mac App Store applications"
        return 0
    fi
    
    validate_config "Mac App Store applications" "${MAS_APPS[@]}" || return 0
    
    logInfo "Installing Mac App Store applications..."
    local -a failed_apps=()
    
    for app in "${MAS_APPS[@]}"; do
        local app_id=$(echo "$app" | awk '{print $1}')
        local app_name=$(echo "$app" | cut -d' ' -f2-)
        
        if mas list | grep -q "^$app_id"; then
            logInfo "$app_name already installed."
        else
            logInfo "Installing $app_name..."
            if ! mas install "$app_id"; then
                failed_apps+=("$app_name")
                logWarn "Failed to install $app_name. Please purchase from App Store first."
                open "macappstore://itunes.apple.com/app/id$app_id" 2>/dev/null || true
            fi
        fi
    done
    
    [[ ${#failed_apps[@]} -gt 0 ]] && logWarn "Failed to install: ${failed_apps[*]}"
}

install_mas_apps

############################################
# Common Setup
############################################

setup_git_lfs
setup_runtime_environment
setup_dotfiles "${DOTFILES[@]}"
setup_shell

############################################
# Xcode Configuration
############################################

logInfo "Configuring Xcode settings..."

# Create directory for Xcode themes if it doesn't exist
XCODE_THEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
mkdir -p "$XCODE_THEMES_DIR"

# Create symlinks for all theme files in .config/xcode directory
XCODE_CONFIG_DIR="$DOTFILE_HOME/.config/xcode"
if [ -d "$XCODE_CONFIG_DIR" ]; then
    for theme_file in "$XCODE_CONFIG_DIR"/*.xccolortheme; do
        if [ -f "$theme_file" ]; then
            theme_name=$(basename "$theme_file")
            theme_dest="$XCODE_THEMES_DIR/$theme_name"
            
            if [ -e "$theme_dest" ] || [ -L "$theme_dest" ]; then
                if [ ! -L "$theme_dest" ]; then
                    mv "$theme_dest" "${theme_dest}.backup"
                    logInfo "Moved existing $theme_dest to ${theme_dest}.backup"
                else
                    rm "$theme_dest"
                    logWarn "Removed existing symlink $theme_dest"
                fi
            fi
            
            ln -s "$theme_file" "$theme_dest"
        fi
    done
else
    logWarn "Xcode config directory $XCODE_CONFIG_DIR does not exist. Skipping theme installation."
fi

logOK "Xcode configuration completed."

############################################
# MacOS System Preferences
############################################

logInfo "Configuring MacOS system preferences..."

# Keyboard settings
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Finder settings
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Restart affected applications
for app in "Finder" "SystemUIServer"; do
    killall "$app" &> /dev/null || true
done

logOK "MacOS system preferences configured."