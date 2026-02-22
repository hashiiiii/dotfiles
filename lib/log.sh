#!/bin/bash

# Source guard: prevent multiple loading
[[ -n "${_LOG_SH_LOADED:-}" ]] && return 0
_LOG_SH_LOADED=1

############################################
# LOG APIs
############################################
logOK()         { _log "$GREEN"   "OK🐶"          "$PLANE"  "$@"; }
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
  printf "${PLANE}[%s] ${color}[%-4s]${text_color} %s\n" "$(date '+%Y-%m-%d %H:%M:%S')" "$level" "$message"
}

# color variation
RED="\e[38;2;247;118;142m"     # ERROR
GREEN="\e[38;2;158;206;106m"   # OK
YELLOW="\e[38;2;224;175;104m"  # WARNING
BLUE="\e[38;2;122;162;247m"    # INFO
PLANE="\e[38;2;192;202;245m"   # Plane color

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
