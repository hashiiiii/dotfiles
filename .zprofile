# Added by Toolbox App
export PATH="$PATH:$HOME/Library/Application Support/JetBrains/Toolbox/scripts"
# Path for installed libraries
# Disabled 2026-05-20: globally exported CPATH/LIBRARY_PATH leaked
# /opt/homebrew/include into Android NDK cross-compile and broke the
# React Native (glog) build for apps/mobile. Re-enable per-project
# (mise.toml/.envrc) or per-build (`PKG_CONFIG_PATH=... cmd`) instead.
# export LIBRARY_PATH="/opt/homebrew/lib"
# Path for C/C++ Header files
# export CPATH="/opt/homebrew/include"
