#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/common.sh"
source "$DOTFILE_HOME/debian.conf"

logInfo 'Running debian.sh...'

############################################
# System Requirements Check
############################################

check_system_requirements "$DOTFILE_HOME/debian.conf" || exit 1

# Debian-specific system checks
check_debian_requirements() {
    # Check if apt is available
    if ! _command_exists apt-get; then
        logErr "apt-get command not found. This script is designed for Debian-based systems."
        return 1
    fi

    # Update package lists
    logInfo "Updating package lists..."
    if ! sudo apt-get update -y; then
        logErr "Failed to update package lists"
        return 1
    fi
    logOK "Package lists updated successfully"
}

check_debian_requirements || exit 1

############################################
# Package Management
############################################

# Install APT packages using refactored function
validate_config "APT packages" "${APT_PACKAGES[@]}" && {
    install_packages "apt" "${APT_PACKAGES[@]}"
}

# Install Snap packages
install_snap_packages() {
    if ! _command_exists snap; then
        logWarn "snapd not available, skipping Snap packages"
        return 0
    fi
    
    validate_config "Snap packages" "${SNAP_PACKAGES[@]}" || return 0
    
    logInfo "Installing Snap packages..."
    local -a failed_packages=()
    
    for pkg in "${SNAP_PACKAGES[@]}"; do
        if ! snap list | grep -q "^$pkg "; then
            logInfo "Installing $pkg..."
            if ! sudo snap install "$pkg"; then
                failed_packages+=("$pkg")
                logWarn "Failed to install $pkg"
            fi
        else
            logInfo "$pkg already installed."
        fi
    done
    
    [[ ${#failed_packages[@]} -gt 0 ]] && logWarn "Failed to install: ${failed_packages[*]}"
}

# Install Flatpak packages
install_flatpak_packages() {
    if ! _command_exists flatpak; then
        logWarn "flatpak not available, skipping Flatpak packages"
        return 0
    fi
    
    validate_config "Flatpak packages" "${FLATPAK_PACKAGES[@]}" || return 0
    
    # Add Flathub repository if not already added
    if ! flatpak remotes | grep -q "flathub"; then
        logInfo "Adding Flathub repository..."
        if ! flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo; then
            logErr "Failed to add Flathub repository"
            return 1
        fi
    fi

    logInfo "Installing Flatpak packages..."
    local -a failed_packages=()
    
    for pkg in "${FLATPAK_PACKAGES[@]}"; do
        if ! flatpak list | grep -q "$pkg"; then
            logInfo "Installing $pkg..."
            if ! flatpak install -y flathub "$pkg"; then
                failed_packages+=("$pkg")
                logWarn "Failed to install $pkg"
            fi
        else
            logInfo "$pkg already installed."
        fi
    done
    
    [[ ${#failed_packages[@]} -gt 0 ]] && logWarn "Failed to install: ${failed_packages[*]}"
}

install_snap_packages
install_flatpak_packages

############################################
# Common Setup
############################################

setup_git_lfs
setup_runtime_environment  
setup_dotfiles "${DOTFILES[@]}"
setup_shell

logOK "Debian installation completed!"
