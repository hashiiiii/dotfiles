#!/bin/bash

set -e

# Error handling
trap 'echo "Error occurred at line $LINENO. Previous command exited with status: $?"' ERR

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/backup.sh"
source "$DOTFILE_HOME/lib/font.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running debian.sh...'

############################################
# System Package Installation
############################################

# Update package list and install required packages
logInfo "Updating package list..."
sudo apt update

logInfo "Installing apt packages..."
for pkg in "${APT_PACKAGES[@]}"; do
  logInfo "Installing $pkg..."
  sudo apt install -y "$pkg"
done
logOK "All required apt packages have been installed."

############################################
# Homebrew Installation
############################################

# Install Homebrew package manager (non-interactive mode)
logInfo "Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

############################################
# Common Setup and Fonts
############################################

# Run common setup script for all platforms
logInfo "Executing common.sh..."
"$DOTFILE_HOME/scripts/common.sh"

# Install Nerd Fonts for terminal
logInfo "Installing Nerd Fonts..."
install_nerd_fonts "$NERD_FONT"
logOK "Nerd Fonts installation completed."

############################################
# Dotfiles Setup
############################################

# Create symlinks for dotfiles with backup
for file in "${DOTFILES[@]}"; do
    backup_dotfile "$DOTFILE_HOME/$file" "$HOME/$file"
done
logOK "dotfiles for Debian installation completed!"

############################################
# Shell Configuration
############################################

# Save current shell and change to zsh
DOTFILES_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
mkdir -p "$DOTFILES_CACHE"
original_shell=$(getent passwd "$USER" | cut -d: -f7)
echo "$original_shell" > "$DOTFILES_CACHE/original_shell"

logInfo "Changing login shell to zsh..."
chsh -s "$(command -v zsh)"

logOK "Login shell changed to zsh."
logInfo "Please restart your terminal (or log out and back in) to start using zsh."
