###########################################
# command aliases (formerly zsh-abbr)
###########################################

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
