#!/bin/bash

set -e

source "$DOTFILE_HOME/lib/log.sh"

# Prevent running as root for security
if [[ "$(id -u)" -eq 0 ]]; then
    logErr "Please do not run this script as root. Run it as a regular user."
    exit 1
fi

# Validate DOTFILE_HOME
if [[ -z "$DOTFILE_HOME" ]]; then
    logErr "DOTFILE_HOME environment variable is not set"
    exit 1
fi

if [[ ! -d "$DOTFILE_HOME" ]]; then
    logErr "DOTFILE_HOME directory does not exist: $DOTFILE_HOME"
    exit 1
fi

logInfo 'Running install.sh...'

# Detect operating system with better error handling
detect_and_run_platform_script() {
    local os_type
    os_type=$(uname -s)
    
    case "$os_type" in
        "Linux")
            if [[ ! -f "/etc/os-release" ]]; then
                logErr "Cannot determine Linux distribution - /etc/os-release not found"
                return 1
            fi
            
            source /etc/os-release
            if [[ "$ID" == "debian" ]] || echo "$ID_LIKE" | grep -qi "debian"; then
                logOK "Debian-based system detected: $PRETTY_NAME"
                if [[ -x "$DOTFILE_HOME/scripts/debian.sh" ]]; then
                    "$DOTFILE_HOME/scripts/debian.sh"
                else
                    logErr "Debian script not found or not executable: $DOTFILE_HOME/scripts/debian.sh"
                    return 1
                fi
            else
                logErr "Unsupported Linux distribution: $PRETTY_NAME (ID: $ID)"
                return 1
            fi
            ;;
        "Darwin")
            logOK "macOS detected."
            if [[ -x "$DOTFILE_HOME/scripts/macosx.sh" ]]; then
                "$DOTFILE_HOME/scripts/macosx.sh"
            else
                logErr "macOS script not found or not executable: $DOTFILE_HOME/scripts/macosx.sh"
                return 1
            fi
            ;;
        *)
            logErr "Unsupported operating system: $os_type"
            return 1
            ;;
    esac
}

# Run platform-specific installation
if detect_and_run_platform_script; then
    logOK "Installation completed successfully!"
else
    logErr "Installation failed!"
    exit 1
fi
