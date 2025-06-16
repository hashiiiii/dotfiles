#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

# Validates input parameters for backup functions
_validate_backup_params() {
    local src="$1"
    local dest="$2"
    
    [[ -z "$src" || -z "$dest" ]] && {
        logErr "Source and destination paths are required"
        return 1
    }
    
    [[ ! -e "$src" ]] && {
        logErr "Source path does not exist: $src"
        return 1
    }
    
    return 0
}

# Creates backup and symlink for dotfiles
backup_dotfile() {
    local src="$1"
    local dest="$2"
    local backup="${dest}.backup"

    _validate_backup_params "$src" "$dest" || return 1

    if [[ -e "$backup" ]]; then
        logErr "Backup file $backup already exists. Please run 'make restore' before installing."
        return 1
    fi

    if [[ -e "$dest" || -L "$dest" ]]; then
        if [[ ! -L "$dest" ]]; then
            if ! mv "$dest" "$backup"; then
                logErr "Failed to create backup: $dest -> $backup"
                return 1
            fi
            logInfo "Moved existing $dest to $backup"
        else
            if ! rm "$dest"; then
                logErr "Failed to remove existing symlink: $dest"
                return 1
            fi
            logWarn "Removed existing symlink $dest"
        fi
    fi

    if ! ln -s "$src" "$dest"; then
        logErr "Failed to create symlink: $src -> $dest"
        return 1
    fi
    
    logInfo "Linked $src to $dest"
}

# Batch backup multiple dotfiles
backup_dotfiles() {
    local -a failed_backups=()
    local count=0
    local total=$#
    
    for file in "$@"; do
        ((count++))
        logStep "$count" "$total" "Backing up $file"
        
        if ! backup_dotfile "$DOTFILE_HOME/$file" "$HOME/$file"; then
            failed_backups+=("$file")
        fi
    done
    
    if [[ ${#failed_backups[@]} -gt 0 ]]; then
        logErr "Failed to backup: ${failed_backups[*]}"
        return 1
    fi
    
    logOK "All dotfiles backed up successfully"
}
