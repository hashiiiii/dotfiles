#!/bin/bash

set -euo pipefail

source "$DOTFILE_HOME/lib/log.sh"
source "$DOTFILE_HOME/lib/restore.sh"
source "$DOTFILE_HOME/macos.conf"

logInfo 'Running restore.sh...'
restore_all "${DOTFILES[@]}"
