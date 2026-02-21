#!/bin/bash

############################################
# LOG APIs
############################################
logOK()         { _log "$GREEN"   "OK$EMOJI_DOG"   "$PLANE"  "$@"; }
logWarn()       { _log "$YELLOW"  "WARN"           "$YELLOW" "$@"; }
logErr()        { _log "$RED"     "ERR_"           "$RED"    "$@"; }
logInfo()       { _log "$BLUE"    "INFO"           "$PLANE"  "$@"; }
logImportant()  { _log "$RED"     "IMPORTANT INFO" "$RED"    "$@"; }

# base method
_log() {
  local color="$1"
  local level="$2"
  local text_color="$3"
  shift 3
  local message="$*"
  printf "${PLANE}[%(%Y-%m-%d %H:%M:%S)T] ${color}[%-4s]${text_color} %s\n" -1 "$level" "$message"
}

# color variation
RED="\e[38;2;247;118;142m"     # ERROR
GREEN="\e[38;2;158;206;106m"   # OK
YELLOW="\e[38;2;224;175;104m"  # WARNING
BLUE="\e[38;2;122;162;247m"    # INFO
PLANE="\e[38;2;192;202;245m"   # Plane color

# check support for emoji dog
SUPPORTS_EMOJI=1
if [[ "${LANG:-}" != *"UTF-8"* ]] && [[ "${LC_ALL:-}" != *"UTF-8"* ]]; then
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
