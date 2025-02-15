#!/bin/bash

set -e

# Error handling
trap 'echo "Error occurred at line $LINENO. Previous command exited with status: $?"' ERR

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/backup.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running debian.sh...'
logInfo "Updating package list..."

sudo apt update

logInfo "Installing apt packages..."

for pkg in "${APT_PACKAGES[@]}"; do
  logInfo "Installing $pkg..."
  sudo apt install -y "$pkg"
done

logOK "All required apt packages have been installed."

logInfo "Installing Homebrew..."
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

logInfo "Executing common.sh..."
"$DOTFILE_HOME/scripts/common.sh"

logInfo "Installing Nerd Fonts..."
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash -s
logOK "Nerd Fonts installation completed."

# Create symlinks for dotfiles using the backup function
for file in "${DOTFILES[@]}"; do
    backup_dotfile "$DOTFILE_HOME/$file" "$HOME/$file"
done

logOK "dotfiles for Debian installation completed!"

logInfo "Changing login shell to zsh..."
chsh -s "$(command -v zsh)"

logOK "Login shell changed to zsh."
logInfo "Please restart your terminal (or log out and back in) to start using zsh."
