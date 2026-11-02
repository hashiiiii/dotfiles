# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/hashiiiii/.docker/bin"
# End of Docker Desktop section.

export HOMEBREW_PREFIX="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"

# Resolve patched runtimes in non-interactive login shells too.
export PATH="$HOME/.local/share/mise/shims:$PATH"

# The patched store removes distrusted roots and is generated separately.
if [ -f "$HOME/.local/share/security-runtimes/java/cacerts-emudhra-fixed" ]; then
  export JAVA_TOOL_OPTIONS="-Djavax.net.ssl.trustStore=$HOME/.local/share/security-runtimes/java/cacerts-emudhra-fixed -Djavax.net.ssl.trustStorePassword=changeit"
fi
