#################################################
# homebrew
#################################################
# Homebrew environment (static, avoids ~20-50ms eval cost)
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

#################################################
# sheldon
#################################################
# load zsh plugin manager
eval "$(sheldon source)"

#################################################
# eza
#################################################
# unset variables for eza
unset LS_COLORS
unset EZA_CONFIG_DIR
# set variables for eza
export EZA_CONFIG_DIR="$HOME/.config/eza"

# abbreviations are managed by zsh-abbr via .config/zsh-abbr/user-abbreviations

#################################################
# history
#################################################
# set history file
HISTFILE=~/.zsh_history
# max digits
HISTSIZE=10000  # in session
SAVEHIST=10000  # in history file
# set history management
setopt appendhistory    # not overwrite but append
setopt incappendhistory # append history to file after command execution
setopt sharehistory     # share history between sesisons
# manage duplicate commands
setopt hist_ignore_dups     # grouping duplicate commands
#setopt hist_ignore_all_dups # remove duplicate commands
setopt hist_reduce_blanks   # reduce unnecessary blanks in commands
# handle history safely
setopt hist_expire_dups_first # delete duplicate history more older

#################################################
# Windsurf
#################################################
if [[ -d "$HOME/.codeium/windsurf/bin" ]]; then
    export PATH="$HOME/.codeium/windsurf/bin:$PATH"
fi

#################################################
# Antigravity
#################################################
if [[ -d "$HOME/.antigravity" ]]; then
    export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
fi

#################################################
# Starship
#################################################
export STARSHIP_CONFIG=~/.config/starship/starship.toml

#################################################
# Android SDK platform-tools
#################################################
ANDROID_SDK_PLATFORM_TOOLS="$HOME/Library/Android/sdk/platform-tools"
if [ -d "$ANDROID_SDK_PLATFORM_TOOLS" ]; then
  export PATH="$PATH:$ANDROID_SDK_PLATFORM_TOOLS"
fi
