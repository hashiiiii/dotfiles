#!/bin/bash

set -euo pipefail

DOTFILE_HOME="${DOTFILE_HOME:?DOTFILE_HOME is not set}"

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/backup.sh"
source "$DOTFILE_HOME/lib/package.sh"
source "$DOTFILE_HOME/macos.conf"

# macOS check
[[ "$(uname -s)" == "Darwin" ]] || { logErr "This script is only supported on macOS."; exit 1; }
[[ "$(id -u)" -ne 0 ]] || { logErr "Do not run as root."; exit 1; }

logInfo 'Running install.sh...'

############################################
# Package Management
############################################

install_homebrew

logInfo "Installing packages via brew bundle..."
brew bundle --file="$DOTFILE_HOME/Brewfile" --no-lock || logWarn "Some packages failed to install. Check output above."

############################################
# Dotfiles Setup
############################################

for file in "${DOTFILES[@]}"; do
    backup_dotfile "$DOTFILE_HOME/$file" "$HOME/$file"
done
logOK "Dotfiles symlink completed."

############################################
# Claude Code Settings
############################################

logInfo 'Setting up Claude Code settings...'
mkdir -p "$HOME/.claude"
backup_dotfile "$DOTFILE_HOME/claude/settings.json" "$HOME/.claude/settings.json"
backup_dotfile "$DOTFILE_HOME/claude/hooks" "$HOME/.claude/hooks"
logOK "Claude Code settings symlink completed."

############################################
# Shell Configuration
############################################

if [[ "$SHELL" != *"zsh"* ]]; then
    DOTFILES_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    mkdir -p "$DOTFILES_CACHE"
    echo "$SHELL" > "$DOTFILES_CACHE/original_shell"

    logInfo "Changing login shell to zsh..."
    chsh -s "$(command -v zsh)"
    logOK "Login shell changed to zsh."
    logInfo "Please restart your terminal to start using zsh."
else
    logInfo "Shell is already set to zsh."
fi

############################################
# Xcode Configuration
############################################

logInfo "Configuring Xcode settings..."

XCODE_THEMES_DIR="$HOME/Library/Developer/Xcode/UserData/FontAndColorThemes"
mkdir -p "$XCODE_THEMES_DIR"

XCODE_CONFIG_DIR="$DOTFILE_HOME/.config/xcode"
if [ -d "$XCODE_CONFIG_DIR" ]; then
    for theme_file in "$XCODE_CONFIG_DIR"/*.xccolortheme; do
        if [ -f "$theme_file" ]; then
            theme_name=$(basename "$theme_file")
            theme_dest="$XCODE_THEMES_DIR/$theme_name"

            if [ -e "$theme_dest" ] || [ -L "$theme_dest" ]; then
                if [ ! -L "$theme_dest" ]; then
                    mv "$theme_dest" "${theme_dest}.backup"
                    logInfo "Moved existing $theme_dest to ${theme_dest}.backup"
                else
                    rm "$theme_dest"
                fi
            fi

            ln -s "$theme_file" "$theme_dest"
        fi
    done
else
    logWarn "Xcode config directory $XCODE_CONFIG_DIR does not exist. Skipping theme installation."
fi

logOK "Xcode configuration completed."

############################################
# MacOS System Preferences
############################################

logInfo "Configuring MacOS system preferences..."

# Keyboard settings
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Finder settings
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
defaults write com.apple.finder AppleShowAllFiles -bool true
defaults write com.apple.finder ShowPathbar -bool true

for app in "Finder" "SystemUIServer"; do
    killall "$app" &> /dev/null || true
done

logOK "MacOS system preferences configured."
logOK "Installation completed!"
