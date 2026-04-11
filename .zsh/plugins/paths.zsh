#!/usr/bin/env zsh

# .NET global tools
if [[ -d "$HOME/.dotnet/tools" ]]; then
    export PATH="$PATH:$HOME/.dotnet/tools"
fi

# Android SDK platform-tools
if [[ -d "$HOME/Library/Android/sdk/platform-tools" ]]; then
    export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
fi
