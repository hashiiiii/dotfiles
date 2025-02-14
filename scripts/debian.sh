#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
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
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

logInfo "Executing common.sh..."
"$DOTFILE_HOME/scripts/common.sh"

logInfo "Installing Nerd Fonts..."
curl -fsSL https://raw.githubusercontent.com/getnf/getnf/main/install.sh | bash -s
logOK "Nerd Fonts installation completed."

for file in "${DOTFILES[@]}"; do
  backup="$HOME/$file.backup"
  if [ -e "$backup" ]; then
    logErr "Backup file $backup already exists. Please run 'make clean' before installing."
    exit 1
  fi
done

for file in "${DOTFILES[@]}"; do
  src="$DOTFILE_HOME/$file"
  dest="$HOME/$file"

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    if [ ! -L "$dest" ]; then
      mv "$dest" "$dest.backup"
      logInfo "Moved existing $dest to $dest.backup"
    else
      rm "$dest"
      logWarn "Removed existing symlink $dest"
    fi
  fi

  ln -s "$src" "$dest"
  logInfo "Linked $src to $dest"
done

logOK "dotfiles for Debian installation completed!"

logInfo "Changing login shell to zsh..."
chsh -s "$(command -v zsh)"

logOK "Login shell changed to zsh."
logInfo "Please restart your terminal (or log out and back in) to start using zsh."
