#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/dotfiles.conf"

logInfo 'Running restore.sh...'

# Function to find the latest backup if no timestamp is specified
find_latest_backup() {
    local file="$1"
    local latest=$(ls -t "${file}.backup"* 2>/dev/null | head -n1)
    echo "$latest"
}

# Clean up nerd-font-setup cache
NERD_FONT_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/nerd-font-setup"
if [ -d "$NERD_FONT_CACHE" ]; then
    rm -rf "$NERD_FONT_CACHE"
    logOK "Removed nerd-font-setup cache: $NERD_FONT_CACHE"
fi

for file in "${DOTFILES[@]}"; do
    dest="$HOME/$file"
    
    # If BACKUP_TIMESTAMP is set, use it to find the specific backup
    if [ -n "$BACKUP_TIMESTAMP" ]; then
        backup="${dest}.backup-${BACKUP_TIMESTAMP}"
        if [ ! -e "$backup" ]; then
            logError "Backup not found: $backup"
            continue
        fi
    else
        # Find the latest backup
        backup=$(find_latest_backup "$dest")
        if [ -z "$backup" ]; then
            logWarn "No backup found for: $dest"
            continue
        fi
    fi

    if [ -L "$dest" ]; then
        rm "$dest"
        logOK "Removed symlink: $dest"
    fi

    mv "$backup" "$dest"
    logOK "Restored from backup: $backup -> $dest"
done

logBom "Dotfiles restoration completed!"
