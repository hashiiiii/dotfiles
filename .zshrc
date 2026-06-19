#################################################
# .zshrc — interactive shell setup
# Role: plugins, shell integrations, history, key bindings, aliases.
# (PATH and environment variables live in .zprofile.)
#################################################

#################################################
# eza
#################################################
# eza reads its theme from EZA_CONFIG_DIR (set in .zprofile); unset LS_COLORS so
# it is not overridden by an inherited value.
unset LS_COLORS

#################################################
# local functions: aliases, fzf commands (`fb`/`sf`), `num`, ...
#################################################
# (N) = NULL_GLOB: don't error if the directory is empty.
for f in "$HOME"/.zsh/plugins/*.zsh(N); do source "$f"; done

#################################################
# tool shell integrations
#################################################
eval "$(mise activate zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
eval "$(fzf --zsh)"          # Ctrl-R history, Ctrl-T files, ALT-C cd

#################################################
# history
#################################################
HISTFILE=~/.zsh_history
HISTSIZE=10000   # in-session
SAVEHIST=10000   # on disk
setopt appendhistory          # append, don't overwrite
setopt incappendhistory       # write after each command, not just on exit
setopt sharehistory           # share across sessions
setopt hist_ignore_dups       # collapse consecutive duplicates
setopt hist_reduce_blanks     # trim redundant whitespace
setopt hist_expire_dups_first # drop duplicates first when trimming

# Up/Down search history by the prefix already typed (prefix match).
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

#################################################
# suggestions + syntax highlighting (brew-installed)
# Sourced LAST: both wrap ZLE widgets, so they must load after every other
# widget/keybinding (fzf, history-search) is defined. autosuggestions before
# fast-syntax-highlighting is the recommended order.
#################################################
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh
