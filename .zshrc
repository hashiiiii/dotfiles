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
