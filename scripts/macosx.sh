#!/bin/bash

set -e

# Error handling
trap 'echo "Error occurred at line $LINENO. Previous command exited with status: $?"' ERR

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/backup.sh"
source "$DOTFILE_HOME/dotfiles.conf"
source "$DOTFILE_HOME/dotfiles.macosx.conf"

logInfo 'Running macosx.sh...'

# System Integrity Protection check
if ! csrutil status | grep -q 'disabled'; then
    logWarn "System Integrity Protection is enabled. Some features might be restricted."
fi

# Check if Xcode Command Line Tools are installed
if ! xcode-select -p &> /dev/null; then
    logInfo "Installing Xcode Command Line Tools..."
    xcode-select --install
    # Wait for xcode-select to complete
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

# Install Homebrew if not already installed
if ! command -v brew &> /dev/null; then
    logInfo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add Homebrew to PATH based on architecture
    if [[ "$(uname -m)" == "arm64" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    logInfo "Homebrew already installed."
fi

# Install macOS-specific Homebrew packages
if [ ${#BREW_PACKAGES[@]} -gt 0 ]; then
    logInfo "Installing macOS-specific Homebrew packages..."
    for pkg in "${BREW_PACKAGES[@]}"; do
        if ! brew list "$pkg" &> /dev/null; then
            logInfo "Installing $pkg..."
            brew install "$pkg"
        else
            logInfo "$pkg already installed."
        fi
    done
fi

# Install Homebrew Casks
if [ ${#BREW_CASKS[@]} -gt 0 ]; then
    logInfo "Installing Homebrew Casks..."
    for cask in "${BREW_CASKS[@]}"; do
        if ! brew list --cask "$cask" &> /dev/null; then
            logInfo "Installing $cask..."
            brew install --cask "$cask"
        else
            logInfo "$cask already installed."
        fi
    done
fi

logInfo "Executing common.sh..."
"$DOTFILE_HOME/scripts/common.sh"

logInfo "Installing Nerd Fonts..."
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash -s
logOK "Nerd Fonts installation completed."

# Create symlinks for dotfiles using the backup function
for file in "${DOTFILES[@]}"; do
    backup_dotfile "$DOTFILE_HOME/$file" "$HOME/$file"
done

logOK "dotfiles for macOS installation completed!"

# Change default shell to zsh (if not already)
if [[ "$SHELL" != *"zsh"* ]]; then
    logInfo "Changing login shell to zsh..."
    chsh -s "$(command -v zsh)"
    logOK "Login shell changed to zsh."
    logInfo "Please restart your terminal (or log out and back in) to start using zsh."
else
    logInfo "Shell is already set to zsh."
fi

# Configure macOS system preferences
logInfo "Configuring macOS system preferences..."

# Faster key repeat
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Show all file extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Show hidden files in Finder
defaults write com.apple.finder AppleShowAllFiles -bool true

# Show path bar in Finder
defaults write com.apple.finder ShowPathbar -bool true

# Restart affected applications
for app in "Finder" "SystemUIServer"; do
    killall "$app" &> /dev/null || true
done

logOK "macOS system preferences configured."