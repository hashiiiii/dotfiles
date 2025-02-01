#!/bin/bash

############################################
# LOG APIs
############################################
logOK()   { _log "$GREEN"  "OK$EMOJI_DOG" "$@"; }
logWarn() { _log "$YELLOW" "WARN"         "$@"; }
logErr()  { _log "$RED"    "ERR_"         "$@"; }
logInfo() { _log "$PLANE"  "INFO"         "$@"; }

# base method
_log() {
  local color="$1"
  local level="$2"
  shift 2
  local message="$*"
  printf "${PLANE}[%s] ${color}[%-4s]${PLANE} %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$message"
}

# color variation
RED="\e[38;2;247;118;142m"     # ERROR
GREEN="\e[38;2;158;206;106m"   # OK
YELLOW="\e[38;2;224;175;104m"  # WARNING
PLANE="\e[38;2;192;202;245m"   # Plane color
WHITE="\e[0m"                  # Unused
BLACK="\e[38;2;36;40;59m"      # Unused
BLUE="\e[38;2;122;162;247m"    # Unused
MAGENTA="\e[38;2;187;154;247m" # Unused
CYAN="\e[38;2;42;195;222m"     # Unused

# check support for emoji dog
SUPPORTS_EMOJI=1
if ! locale | grep -q "UTF-8"; then
  SUPPORTS_EMOJI=0
fi

EMOJI_DOG="🐶"
if [[ $SUPPORTS_EMOJI -eq 0 ]]; then
  EMOJI_DOG="__"
fi

############################################
# Test (Only when executed directly)
############################################
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  logInfo "Running tests for log.sh..."
  logOK   "Installation succeeded."
  logWarn "Something might be slow."
  logErr  "Something went wrong."
  logInfo "This is a log message."
fi
