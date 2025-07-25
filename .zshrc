#################################################
# homebrew
#################################################
# configure homebrew environment variables for the current session
if [[ "$(uname)" == "Darwin" ]]; then
    # MacOS (check for both Apple Silicon and Intel paths)
    if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -f "/usr/local/bin/brew" ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    # Linux
    if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

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

#################################################
# alias
#################################################
# create map: "key=st, value='git status'"
declare -A abbreviations=(
  ## git
  [st]="git status"
  [pu]="git pull"
  [fe]="git fetch -p"
  [cm]="git commit"
  [co]="git checkout"
  [br]="git branch"
  ## cd
  # Dynamic workspace path based on OS:
  # - MacOS: Uses ~/Workspace (in user's home directory)
  # - Linux: Uses /mnt/d/Workspace (Windows WSL mounted path)
  # You can modify these paths according to your environment
  [wo]="if [[ $(uname) == \"Darwin\" ]]; then cd ~/workspace; else cd /mnt/d/workspace; fi"
  ## eza
  [ls]="eza --icons --git"
  [la]="eza -a --icons --git"
  [ll]="eza -aahl --icons --git"
  [lt]="eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons"
)
# get stdout from abbr command
current_abbr=$(abbr)
# set alias to abbr
for key value in "${(@kv)abbreviations}"; do
  if ! echo "$current_abbr" | grep -q "\"$key\"="; then
    abbr -f "$key"="$value"
  fi
done

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
# Kiro
#################################################
if [[ -d "$HOME/.kiro" ]]; then
    [[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"
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
