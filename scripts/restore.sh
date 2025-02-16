#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running restore.sh...'

# Clean up nerd-font-setup cache
NERD_FONT_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/nerd-font-setup"
if [ -d "$NERD_FONT_CACHE" ]; then
    rm -rf "$NERD_FONT_CACHE"
    logInfo "Removed nerd-font-setup cache: $NERD_FONT_CACHE"
fi

for file in "${DOTFILES[@]}"; do
  dest="$HOME/$file"
  backup="$dest.backup"

  if [ -L "$dest" ]; then
    rm "$dest"
    logInfo "Removed symlink $dest"
  fi

  if [ -e "$backup" ]; then
    mv "$backup" "$dest"
    logInfo "Restored backup $backup to $dest"
  fi
done
logOK "Dotfiles reversion completed!"
