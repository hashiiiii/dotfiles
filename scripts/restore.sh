#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running restore.sh...'

# Clean up and restore from dotfiles cache
DOTFILES_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"

# Restore original shell
if [ -f "$DOTFILES_CACHE/original_shell" ]; then
    original_shell=$(cat "$DOTFILES_CACHE/original_shell")
    if [ -x "$original_shell" ]; then
        logInfo "Changing shell back to $original_shell..."
        chsh -s "$original_shell"
        rm "$DOTFILES_CACHE/original_shell"
        logOK "Shell restored to $original_shell"
        logInfo "Please restart your terminal (or log out and back in) for changes to take effect."
    else
        logWarn "Original shell $original_shell is not executable or does not exist."
    fi
fi

# Clean up nerd-fonts cache
if [ -d "$DOTFILES_CACHE/nerd-fonts" ]; then
    rm -rf "$DOTFILES_CACHE/nerd-fonts"
    logInfo "Removed nerd-fonts cache"
fi

# Clean up entire cache directory if empty
if [ -d "$DOTFILES_CACHE" ] && [ -z "$(ls -A "$DOTFILES_CACHE")" ]; then
    rm -rf "$DOTFILES_CACHE"
    logInfo "Removed empty dotfiles cache directory"
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
