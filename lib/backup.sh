#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

backup_dotfile() {
    local src="$1"
    local dest="$2"
    local backup="${dest}.backup"

    if [ -e "$backup" ]; then
        logErr "Backup file $backup already exists. Please run 'make clean' before installing."
        return 1
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ ! -L "$dest" ]; then
            mv "$dest" "$backup"
            logInfo "Moved existing $dest to $backup"
        else
            rm "$dest"
            logWarn "Removed existing symlink $dest"
        fi
    fi

    ln -s "$src" "$dest"
    logInfo "Linked $src to $dest"
}
