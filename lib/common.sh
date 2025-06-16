#!/bin/bash

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/backup.sh"
source "$DOTFILE_HOME/lib/font.sh"
source "$DOTFILE_HOME/lib/package.sh"

# Common system checks
check_system_requirements() {
    # Prevent running as root for security
    if [[ "$(id -u)" -eq 0 ]]; then
        logErr "Please do not run this script as root. Run it as a regular user."
        return 1
    fi
    
    # Check if DOTFILE_HOME is set
    if [[ -z "$DOTFILE_HOME" ]]; then
        logErr "DOTFILE_HOME environment variable is not set"
        return 1
    fi
    
    # Check if configuration file exists
    local config_file="$1"
    if [[ ! -f "$config_file" ]]; then
        logErr "Configuration file not found: $config_file"
        return 1
    fi
    
    return 0
}

# Common Git LFS initialization
setup_git_lfs() {
    if _command_exists git; then
        logInfo 'Initializing Git LFS...'
        if ! git lfs install; then
            logWarn "Failed to initialize Git LFS"
            return 1
        fi
        logOK "Git LFS initialized successfully"
    else
        logWarn "Git not found, skipping Git LFS initialization"
    fi
}

# Common shell configuration
setup_shell() {
    if [[ "$SHELL" == *"zsh"* ]]; then
        logInfo "Shell is already set to zsh."
        return 0
    fi
    
    if ! _command_exists zsh; then
        logErr "zsh is not installed"
        return 1
    fi
    
    local cache_dir="${XDG_CACHE_HOME:-$HOME/.cache}/dotfiles"
    mkdir -p "$cache_dir"
    echo "$SHELL" > "$cache_dir/original_shell"

    logInfo "Changing login shell to zsh..."
    local chsh_cmd
    if [[ "$OSTYPE" == "darwin"* ]]; then
        chsh_cmd="chsh -s"
    else
        chsh_cmd="sudo chsh -s"
    fi
    
    if $chsh_cmd "$(command -v zsh)" ${USER:+"$USER"}; then
        logOK "Login shell changed to zsh."
        logInfo "Please restart your terminal (or log out and back in) to start using zsh."
    else
        logErr "Failed to change shell to zsh"
        return 1
    fi
}

# Common dotfiles setup
setup_dotfiles() {
    local -a dotfiles=("$@")
    
    if [[ ${#dotfiles[@]} -eq 0 ]]; then
        logWarn "No dotfiles specified for setup"
        return 0
    fi
    
    logInfo "Setting up ${#dotfiles[@]} dotfiles..."
    if backup_dotfiles "${dotfiles[@]}"; then
        logOK "Dotfiles setup completed successfully"
    else
        logErr "Dotfiles setup failed"
        return 1
    fi
}

# Common runtime environment setup
setup_runtime_environment() {
    logInfo "Setting up runtime environment..."
    
    if ! install_mise; then
        logWarn "Failed to install mise, continuing without runtime version management"
    fi
    
    logInfo "Installing Nerd Fonts..."
    if install_nerd_fonts "${NERD_FONT:-JetBrainsMono}"; then
        logOK "Nerd Fonts installation completed."
    else
        logWarn "Nerd Fonts installation failed, continuing..."
    fi
}

# Validate configuration arrays
validate_config() {
    local config_name="$1"
    shift
    local -a config_array=("$@")
    
    if [[ ${#config_array[@]} -eq 0 ]]; then
        logInfo "No $config_name configured, skipping..."
        return 1
    fi
    
    logInfo "Found ${#config_array[@]} $config_name to process"
    return 0
}