unset LS_COLORS

# git
alias br='git branch'
alias cm='git commit'
alias co='git checkout'
alias fe='git fetch -p'
alias pu='git pull'
alias st='git status'

# eza / bat
alias cat='bat'
alias la='eza -a --icons --git'
alias ll='eza -aahl --icons --git'
alias ls='eza --icons --git'
alias lt="eza -T -L 3 -a -I 'node_modules|.git|.cache' --icons"

# navigation
alias wo='cd ~/workspace'

# cursor-agent: auto-load the newest installed superpowers plugin (version-proof).
# Falls back to plain cursor-agent if the plugin isn't present. Use `command
# cursor-agent` to run without superpowers.
cursor-agent() {
  emulate -L zsh
  setopt local_options null_glob
  local -a sp
  sp=( "$HOME"/.claude/plugins/cache/claude-plugins-official/superpowers/*/ )
  if (( $#sp )); then
    sp=( ${(On)sp} )   # numeric sort, highest version first
    command cursor-agent --plugin-dir "${sp[1]%/}" "$@"
  else
    command cursor-agent "$@"
  fi
}

eval "$(mise activate zsh)"

# dir jumping (replaces zoxide): type a dir name to cd; cd searches these parents
setopt AUTO_CD
cdpath=(~ ~/workspace)

HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
setopt incappendhistory
setopt sharehistory
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_expire_dups_first

autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# prompt (replaces starship): cwd + git branch/dirty + success-colored ❯
autoload -Uz vcs_info add-zsh-hook
setopt PROMPT_SUBST
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' unstagedstr '*'
zstyle ':vcs_info:git:*' stagedstr  '+'
zstyle ':vcs_info:git:*' formats       ' %F{magenta}%b%f%F{yellow}%u%c%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}%b|%a%f'
add-zsh-hook precmd vcs_info
PROMPT='%F{blue}%~%f${vcs_info_msg_0_} %(?.%F{green}.%F{red})❯%f '

source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

# Authentic Tokyo Night palette for fast-syntax-highlighting (Night variant hexes).
# Ghostty is truecolor, so fg=#rrggbb renders exactly. Must run AFTER sourcing FSH.
typeset -A FAST_HIGHLIGHT_STYLES
FAST_HIGHLIGHT_STYLES[default]='fg=#c0caf5'
FAST_HIGHLIGHT_STYLES[unknown-token]='fg=#f7768e'
FAST_HIGHLIGHT_STYLES[reserved-word]='fg=#bb9af7'
FAST_HIGHLIGHT_STYLES[alias]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[suffix-alias]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[global-alias]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[builtin]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[function]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[command]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[precommand]='fg=#2ac3de'
FAST_HIGHLIGHT_STYLES[hashed-command]='fg=#7aa2f7'
FAST_HIGHLIGHT_STYLES[commandseparator]='fg=#89ddff'
FAST_HIGHLIGHT_STYLES[path]='fg=#c0caf5'
FAST_HIGHLIGHT_STYLES[path_pathseparator]='fg=#565f89'
FAST_HIGHLIGHT_STYLES[single-hyphen-option]='fg=#ff9e64'
FAST_HIGHLIGHT_STYLES[double-hyphen-option]='fg=#ff9e64'
FAST_HIGHLIGHT_STYLES[single-quoted-argument]='fg=#9ece6a'
FAST_HIGHLIGHT_STYLES[double-quoted-argument]='fg=#9ece6a'
FAST_HIGHLIGHT_STYLES[dollar-quoted-argument]='fg=#9ece6a'
FAST_HIGHLIGHT_STYLES[back-quoted-argument]='fg=#7dcfff'
FAST_HIGHLIGHT_STYLES[command-substitution]='fg=#7dcfff'
FAST_HIGHLIGHT_STYLES[globbing]='fg=#bb9af7'
FAST_HIGHLIGHT_STYLES[redirection]='fg=#89ddff'
FAST_HIGHLIGHT_STYLES[variable]='fg=#bb9af7'
FAST_HIGHLIGHT_STYLES[mathnum]='fg=#ff9e64'
FAST_HIGHLIGHT_STYLES[comment]='fg=#565f89'
