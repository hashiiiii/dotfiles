#!/bin/bash

set -euo pipefail

DOTFILE_DIR=""
REPO_URL="https://github.com/hashiiiii/dotfiles.git"

while getopts "o:" opt; do
    case "$opt" in
        o) DOTFILE_DIR="$OPTARG" ;;
        *) echo "Usage: install [-o directory]"; exit 1 ;;
    esac
done

DOTFILE_DIR="${DOTFILE_DIR:-$HOME/.dotfiles}"

if [ -d "$DOTFILE_DIR" ]; then
    echo "Already exists: $DOTFILE_DIR"
    echo "Pulling latest changes..."
    git -C "$DOTFILE_DIR" pull
else
    echo "Cloning dotfiles..."
    git clone "$REPO_URL" "$DOTFILE_DIR"
fi

cd "$DOTFILE_DIR"
make setup && make install
