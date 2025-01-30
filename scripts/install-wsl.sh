#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"

logInfo "Installing dotfiles for WSL..."

DOTFILES=(
  .config
  .zsh
  .Brewfile
  .zshrc
)

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
  logOK "Linked $src to $dest"
done

logOK "WSL dotfiles installation completed!"
