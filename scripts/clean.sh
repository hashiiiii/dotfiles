#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running clean.sh...'

for file in "${DOTFILES[@]}"; do
  dest="$HOME/$file"
  backup="$dest.backup"

  if [ -L "$dest" ]; then
    rm "$dest"
    echo "Removed symlink $dest"
  fi

  if [ -e "$backup" ]; then
    mv "$backup" "$dest"
    echo "Restored backup $backup to $dest"
  fi
done
echo "Dotfiles reversion completed!"
