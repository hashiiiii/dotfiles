#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

# Check if command exists
_command_exists() {
    command -v "$1" &> /dev/null
}

# Install mise version manager with error handling
install_mise() {
    if _command_exists mise; then
        logInfo "mise already installed."
        return 0
    fi
    
    logInfo "Installing mise..."
    if ! curl -fsSL https://mise.run | sh; then
        logErr "Failed to install mise"
        return 1
    fi
    logOK "mise installation completed."
}

# Install Homebrew with improved error handling
install_homebrew() {
    if _command_exists brew; then
        logInfo "Homebrew already installed."
        return 0
    fi
    
    logInfo "Installing Homebrew..."
    if ! /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
        logErr "Failed to install Homebrew"
        return 1
    fi
    
    # Add Homebrew to PATH based on architecture
    local brew_path
    if [[ "$(uname -m)" == "arm64" ]]; then
        brew_path="/opt/homebrew/bin/brew"
    else
        brew_path="/usr/local/bin/brew"
    fi
    
    if [[ -f "$brew_path" ]]; then
        eval "$($brew_path shellenv)"
        logOK "Homebrew installation completed."
    else
        logErr "Homebrew binary not found after installation"
        return 1
    fi
}

# Install packages with error handling
install_packages() {
    local package_manager="$1"
    shift
    local -a packages=("$@")
    local -a failed_packages=()
    
    [[ ${#packages[@]} -eq 0 ]] && {
        logWarn "No packages specified for $package_manager"
        return 0
    }
    
    logInfo "Installing ${#packages[@]} packages via $package_manager..."
    
    for pkg in "${packages[@]}"; do
        case "$package_manager" in
            "brew")
                if ! brew list "$pkg" &> /dev/null; then
                    logInfo "Installing $pkg..."
                    if ! brew install "$pkg"; then
                        failed_packages+=("$pkg")
                        logWarn "Failed to install $pkg"
                    fi
                else
                    logInfo "$pkg already installed."
                fi
                ;;
            "brew-cask")
                if ! brew list --cask "$pkg" &> /dev/null; then
                    logInfo "Installing cask $pkg..."
                    if ! brew install --cask "$pkg"; then
                        failed_packages+=("$pkg")
                        logWarn "Failed to install cask $pkg"
                    fi
                else
                    logInfo "Cask $pkg already installed."
                fi
                ;;
            "apt")
                if ! dpkg -l | grep -q "ii  $pkg "; then
                    logInfo "Installing $pkg..."
                    if ! sudo apt-get install -y "$pkg"; then
                        failed_packages+=("$pkg")
                        logWarn "Failed to install $pkg"
                    fi
                else
                    logInfo "$pkg already installed."
                fi
                ;;
            *)
                logErr "Unsupported package manager: $package_manager"
                return 1
                ;;
        esac
    done
    
    if [[ ${#failed_packages[@]} -gt 0 ]]; then
        logWarn "Failed to install packages: ${failed_packages[*]}"
        return 1
    fi
    
    logOK "All $package_manager packages installed successfully"
}
