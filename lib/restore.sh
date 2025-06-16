#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"

# Check if command exists
_command_exists() {
    command -v "$1" &> /dev/null
}

# Restore the original shell from cache
restore_shell() {
    local dotfiles_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    local shell_cache="$dotfiles_cache/original_shell"

    if [[ ! -f "$shell_cache" ]]; then
        logInfo "No original shell cache found, skipping shell restoration"
        return 0
    fi
    
    local original_shell
    original_shell=$(cat "$shell_cache")
    
    if [[ ! -x "$original_shell" ]]; then
        logWarn "Original shell $original_shell is not executable or does not exist."
        return 1
    fi
    
    logInfo "Changing shell back to $original_shell..."
    local chsh_cmd
    if [[ "$OSTYPE" == "darwin"* ]]; then
        chsh_cmd="chsh -s"
    else
        chsh_cmd="sudo chsh -s"
    fi
    
    if $chsh_cmd "$original_shell" ${USER:+"$USER"}; then
        rm "$shell_cache"
        logOK "Shell restored to $original_shell"
        logInfo "Please restart your terminal (or log out and back in) for changes to take effect."
    else
        logErr "Failed to restore shell to $original_shell"
        return 1
    fi
}

# Clean up nerd-fonts cache
cleanup_nerd_fonts() {
    local dotfiles_cache="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    local fonts_cache="$dotfiles_cache/nerd-fonts"

    if [ -d "$fonts_cache" ]; then
        rm -rf "$fonts_cache"
        logInfo "Removed nerd-fonts cache"
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
    local -a dotfiles=("$@")
    local -a failed_restores=()
    local -a missing_backups=()
    
    if [[ ${#dotfiles[@]} -eq 0 ]]; then
        logWarn "No dotfiles specified for restoration"
        return 0
    fi
    
    logInfo "Restoring ${#dotfiles[@]} dotfiles..."
    
    for file in "${dotfiles[@]}"; do
        local dest="$HOME/$file"
        local backup="$dest.backup"

        # Remove symlink if it exists
        if [[ -L "$dest" ]]; then
            if ! rm "$dest"; then
                logErr "Failed to remove symlink: $dest"
                failed_restores+=("$file")
                continue
            fi
            logInfo "Removed symlink $dest"
        elif [[ -e "$dest" ]]; then
            logWarn "File $dest exists but is not a symlink, skipping removal"
        fi

        # Restore backup if it exists
        if [[ -e "$backup" ]]; then
            if ! mv "$backup" "$dest"; then
                logErr "Failed to restore backup: $backup -> $dest"
                failed_restores+=("$file")
            else
                logInfo "Restored backup $backup to $dest"
            fi
        else
            missing_backups+=("$file")
        fi
    done
    
    # Report results
    if [[ ${#missing_backups[@]} -gt 0 ]]; then
        logInfo "No backups found for: ${missing_backups[*]}"
    fi
    
    if [[ ${#failed_restores[@]} -gt 0 ]]; then
        logErr "Failed to restore: ${failed_restores[*]}"
        return 1
    fi
    
    logOK "Dotfiles restoration completed!"
}

# Restore everything
restore_all() {
    restore_shell
    cleanup_nerd_fonts
    restore_dotfiles "$@"
    cleanup_cache
}

# If script is run directly (not sourced), perform full restore
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Detect OS for loading the appropriate configuration
    OS=$(uname -s)
    if [[ "$OS" == "Linux" ]]; then
        # For Linux, check if it's Debian-based
        source /etc/os-release
        if [ "$ID" = "debian" ] || echo "$ID_LIKE" | grep -qi "debian"; then
            source "$DOTFILE_HOME/debian.conf"
        else
            logErr "Unsupported Linux distribution: $ID"
            exit 1
        fi
    elif [[ "$OS" == "Darwin" ]]; then
        source "$DOTFILE_HOME/macos.conf"
    else
        logErr "Unsupported OS: $OS"
        exit 1
    fi
    
    logInfo 'Running restore...'
    restore_all "${DOTFILES[@]}"
fi
