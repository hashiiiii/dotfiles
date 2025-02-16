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
# terminal
#################################################
# Enable UTF-8 for icons
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
# Configure terminal to use Nerd Font
if [[ -n "$TERMINAL_EMULATOR" ]] || [[ -n "$TERM_PROGRAM" ]]; then
    # Set terminal font (this is just informational, you need to set this in your terminal emulator)
    if [[ "$(uname)" == "Darwin" ]]; then
        # macOS terminal font setting reminder
        : # JetBrainsMono Nerd Font needs to be set in Terminal.app or iTerm2 preferences
    else
        # Linux/WSL terminal font setting reminder
        : # JetBrainsMono Nerd Font needs to be set in your terminal emulator settings
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
  [wo]="if [[ \"$(uname)\" == \"Darwin\" ]]; then cd ~/Workspace; else cd /mnt/d/Workspace; fi"
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
