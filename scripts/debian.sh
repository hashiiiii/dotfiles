#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/backup.sh"
source "$DOTFILE_HOME/lib/font.sh"
source "$DOTFILE_HOME/lib/package.sh"
source "$DOTFILE_HOME/debian.conf"

logInfo 'Running debian.sh...'

############################################
# System Requirements Check
############################################

# Check if apt is available
if ! command -v apt-get &> /dev/null; then
    logErr "apt-get command not found. This script is designed for Debian-based systems."
    exit 1
fi

# Update package lists
logInfo "Updating package lists..."
sudo apt-get update -y

############################################
# Package Management
############################################

# Install essential packages
if [ ${#APT_PACKAGES[@]} -gt 0 ]; then
    logInfo "Installing APT packages..."
    for pkg in "${APT_PACKAGES[@]}"; do
        if ! dpkg -l | grep -q "ii  $pkg "; then
            logInfo "Installing $pkg..."
            sudo apt-get install -y "$pkg" || logWarn "Failed to install $pkg. Continuing with installation..."
        else
            logInfo "$pkg already installed."
        fi
    done
fi

# Install Snap packages if snapd is available
if command -v snap &> /dev/null && [ ${#SNAP_PACKAGES[@]} -gt 0 ]; then
    logInfo "Installing Snap packages..."
    for pkg in "${SNAP_PACKAGES[@]}"; do
        if ! snap list | grep -q "^$pkg "; then
            logInfo "Installing $pkg..."
            sudo snap install "$pkg" || logWarn "Failed to install $pkg. Continuing with installation..."
        else
            logInfo "$pkg already installed."
        fi
    done
fi

# Install Flatpak packages if flatpak is available
if command -v flatpak &> /dev/null && [ ${#FLATPAK_PACKAGES[@]} -gt 0 ]; then
    # Add Flathub repository if not already added
    if ! flatpak remotes | grep -q "flathub"; then
        logInfo "Adding Flathub repository..."
        flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    fi

    logInfo "Installing Flatpak packages..."
    for pkg in "${FLATPAK_PACKAGES[@]}"; do
        if ! flatpak list | grep -q "$pkg"; then
            logInfo "Installing $pkg..."
            flatpak install -y flathub "$pkg" || logWarn "Failed to install $pkg. Continuing with installation..."
        else
            logInfo "$pkg already installed."
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
logOK "dotfiles for Debian installation completed!"

############################################
# Shell Configuration
############################################

# Change default shell to zsh if needed
if [[ "$SHELL" != *"zsh"* ]]; then
    DOTFILES_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    mkdir -p "$DOTFILES_CACHE"
    echo "$SHELL" > "$DOTFILES_CACHE/original_shell"

    logInfo "Changing login shell to zsh..."
    sudo chsh -s "$(command -v zsh)" "$USER"
    logOK "Login shell changed to zsh."
    logInfo "Please restart your terminal (or log out and back in) to start using zsh."
else
    logInfo "Shell is already set to zsh."
fi
