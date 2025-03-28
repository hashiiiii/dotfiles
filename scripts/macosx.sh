#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/backup.sh"
source "$DOTFILE_HOME/lib/font.sh"
source "$DOTFILE_HOME/lib/package.sh"
source "$DOTFILE_HOME/macos.conf"

logInfo 'Running macosx.sh...'

############################################
# System Requirements Check
############################################

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
        softwareupdate --install-rosetta --agree-to-license
        logOK "Rosetta 2 installation completed."
    else
        logInfo "Rosetta 2 already installed."
    fi
fi

############################################
# Package Management
############################################

# Install and configure Homebrew
install_homebrew

# Install Homebrew taps
if [ ${#BREW_TAPS[@]} -gt 0 ]; then
    logInfo "Adding Homebrew taps..."
    for tap in "${BREW_TAPS[@]}"; do
        if ! brew tap | grep -q "$tap"; then
            logInfo "Adding tap: $tap..."
            brew tap "$tap" || logWarn "Failed to add tap: $tap. Continuing with installation..."
        else
            logInfo "Tap $tap already added."
        fi
    done
fi

# Install packages and casks
if [ ${#BREW_PACKAGES[@]} -gt 0 ]; then
    logInfo "Installing MacOS-specific Homebrew packages..."
    for pkg in "${BREW_PACKAGES[@]}"; do
        if ! brew list "$pkg" &> /dev/null; then
            logInfo "Installing $pkg..."
            brew install "$pkg" || logWarn "Failed to install $pkg. Continuing with installation..."
        else
            logInfo "$pkg already installed."
        fi
    done
fi

if [ ${#BREW_CASKS[@]} -gt 0 ]; then
    logInfo "Installing Homebrew Casks..."
    for cask in "${BREW_CASKS[@]}"; do
        if ! brew list --cask "$cask" &> /dev/null; then
            logInfo "Installing $cask..."
            brew install --cask "$cask" || logWarn "Failed to install cask $cask. Continuing with installation..."
        else
            logInfo "$cask already installed."
        fi
    done
fi

# Install Mac App Store applications
if command -v mas &> /dev/null && [ ${#MAS_APPS[@]} -gt 0 ]; then
    logInfo "Installing Mac App Store applications..."
    
    # Note: mas account command is not supported on newer macOS versions
    # We'll try to install apps directly without checking sign-in status
    logInfo "Attempting to install Mac App Store applications..."
    
    for app in "${MAS_APPS[@]}"; do
        app_id=$(echo "$app" | awk '{print $1}')
        app_name=$(echo "$app" | cut -d' ' -f2-)
        
        if mas list | grep -q "^$app_id"; then
            logInfo "$app_name already installed."
        else
            logInfo "Installing $app_name..."
            if ! mas install "$app_id"; then
                if [[ $? -eq 1 ]]; then
                    logWarn "Failed to install $app_name. It might be because this is the first time you're trying to install this app."
                    logInfo "Please purchase $app_name directly from the App Store first. After purchasing, you can use 'mas install' for reinstallation."
                    open "macappstore://itunes.apple.com/app/id$app_id"
                else
                    logWarn "Failed to install $app_name. Continuing with installation..."
                fi
            fi
        fi
    done
fi

############################################
# Common Setup and Fonts
############################################

# Initialize Git LFS
logInfo 'Initializing Git LFS...'
git lfs install

# Install mise version manager
install_mise

# Install Nerd Fonts
logInfo "Installing Nerd Fonts..."
install_nerd_fonts "$NERD_FONT"
logOK "Nerd Fonts installation completed."

############################################
# Dotfiles Setup
############################################

# Create symlinks for dotfiles
for file in "${DOTFILES[@]}"; do
    backup_dotfile "$DOTFILE_HOME/$file" "$HOME/$file"
done
logOK "dotfiles for macOS installation completed!"

############################################
# Shell Configuration
############################################

# Change default shell to zsh if needed
if [[ "$SHELL" != *"zsh"* ]]; then
    DOTFILES_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    mkdir -p "$DOTFILES_CACHE"
    echo "$SHELL" > "$DOTFILES_CACHE/original_shell"

    logInfo "Changing login shell to zsh..."
    chsh -s "$(command -v zsh)"
    logOK "Login shell changed to zsh."
    logInfo "Please restart your terminal (or log out and back in) to start using zsh."
else
    logInfo "Shell is already set to zsh."
fi

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