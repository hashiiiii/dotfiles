#################################################
# .zprofile — login shell, runs ONCE before .zshrc
# Role: environment variables and PATH only.
# (Interactive UI / plugins / aliases / prompt live in .zshrc.)
#################################################

#################################################
# Homebrew
#################################################
# Static export instead of `eval "$(brew shellenv)"` to avoid its ~20-50ms cost.
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
export MANPATH="/opt/homebrew/share/man${MANPATH+:$MANPATH}:"
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

#################################################
# Tooling PATH
#################################################
# JetBrains Toolbox CLI launchers
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
# .NET global tools
[ -d "$HOME/.dotnet/tools" ] && export PATH="$PATH:$HOME/.dotnet/tools"
# Android SDK platform-tools
[ -d "$HOME/Library/Android/sdk/platform-tools" ] && export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"

# NOTE: do NOT globally export LIBRARY_PATH/CPATH here.
# Disabled 2026-05-20: exporting /opt/homebrew/{lib,include} globally leaked into
# the Android NDK cross-compile and broke the React Native (glog) build for
# apps/mobile. Set them per-project (mise.toml / .envrc) or per-build instead.

#################################################
# Tool config locations (env only; shell activation happens in .zshrc)
#################################################
export EZA_CONFIG_DIR="$HOME/.config/eza"
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
