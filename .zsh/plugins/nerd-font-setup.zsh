# Enable UTF-8 for icons and Nerd Font support
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Setup cache directory
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nerd-font-setup"
mkdir -p "$CACHE_DIR"

# Load or initialize setup status
if [[ -f "$CACHE_DIR/setup_done" ]]; then
    export NERD_FONT_SETUP_DONE=1
else
    export NERD_FONT_SETUP_DONE=0
fi

# Function to mark font setup as complete
nerd_font_done() {
    export NERD_FONT_SETUP_DONE=1
    touch "$CACHE_DIR/setup_done"
    echo "\033[1;32m✓\033[0m Font setup message hidden"
}

# Show font setup message if not done
if [[ "$NERD_FONT_SETUP_DONE" != "1" ]]; then
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
