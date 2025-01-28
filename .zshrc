#################################################
# homebrew
#################################################
# configure homebrew environment variables for the current session
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

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
  [wo]="cd /mnt/d/Workspace"
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
