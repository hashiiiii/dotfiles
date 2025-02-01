#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

for file in "${DOTFILES[@]}"; do
  backup="$HOME/$file.backup"
  if [ -e "$backup" ]; then
    logErr "Backup file $backup already exists. Please run 'make clean' before installing."
    exit 1
  fi
done

logInfo 'Running debian.sh...'

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
