# Enable UTF-8 for icons and Nerd Font support
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Nerd Font setup status (0: not done, 1: done)
export NERD_FONT_SETUP_SHOWN=0

# Function to mark font setup as complete
nerd_font_done() {
    local zshrc="$HOME/.zshrc"
    if [[ -f "$zshrc" ]]; then
        # Update the variable in the plugin file instead
        local plugin_file="${${(%):-%x}:A}"
        if [[ -f "$plugin_file" ]]; then
            sed -i 's/^export NERD_FONT_SETUP_SHOWN=0/export NERD_FONT_SETUP_SHOWN=1/' "$plugin_file"
            export NERD_FONT_SETUP_SHOWN=1
            echo "\033[1;32m✓\033[0m Font setup message hidden"
            echo "Please restart your terminal or run: source ~/.zshrc"
        fi
    fi
}

# Show font setup message once
if [[ "$NERD_FONT_SETUP_SHOWN" != "1" ]]; then
    echo "\033[1;34mℹ️  Terminal Font Setup\033[0m"
    echo "Please set \033[1mJetBrainsMono Nerd Font\033[0m in your terminal:"
    
    if [[ -d "/mnt/c/Windows" ]]; then
        echo "   Windows Terminal: Settings (Ctrl+,) → WSL Profile → Appearance"
    elif [[ "$(uname)" == "Darwin" ]]; then
        if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
            echo "   iTerm2: Preferences (⌘,) → Profiles → Text → Font"
        else
            echo "   Terminal.app: Preferences (⌘,) → Profiles → Text → Change Font"
        fi
    fi
    
    echo "\nAfter setting the font, run this command to hide this message:"
    echo "   \033[1mnerd_font_done\033[0m"
fi
