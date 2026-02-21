#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

# Restore the original shell from cache
restore_shell() {
    local dotfiles_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    local shell_cache="$dotfiles_cache/original_shell"

    if [ -f "$shell_cache" ]; then
        local original_shell=$(cat "$shell_cache")
        if [ -x "$original_shell" ]; then
            logInfo "Changing shell back to $original_shell..."
            chsh -s "$original_shell"
            rm "$shell_cache"
            logOK "Shell restored to $original_shell"
            logInfo "Please restart your terminal (or log out and back in) for changes to take effect."
        else
            logWarn "Original shell $original_shell is not executable or does not exist."
        fi
    fi
}

# Clean up the dotfiles cache directory if empty
cleanup_cache() {
    local dotfiles_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"

    if [ -d "$dotfiles_cache" ] && [ -z "$(ls -A "$dotfiles_cache")" ]; then
        rm -rf "$dotfiles_cache"
        logInfo "Removed empty dotfiles cache directory"
    fi
}

# Restore original files from backups
restore_dotfiles() {
    local dotfiles=("$@")

    for file in "${dotfiles[@]}"; do
        local dest="$HOME/$file"
        local backup="$dest.backup"

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
}

# Restore everything
restore_all() {
    restore_shell
    restore_dotfiles "$@"
    cleanup_cache
}

# If script is run directly (not sourced), perform full restore
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    source "$DOTFILE_HOME/macos.conf"

    logInfo 'Running restore...'
    restore_all "${DOTFILES[@]}"
fi
