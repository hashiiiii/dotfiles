###########################################
# ref: https://github.com/junegunn/fzf/wiki
###########################################

# List and switch branches interactively
fb() {
  local branches branch
  branches=$(git --no-pager branch -vv) &&
  branch=$(echo "$branches" | fzf +m) &&
  git checkout "$(echo "$branch" | awk '{print $1}' | sed "s/.* //")"
}

# search file contents for a specific string
sf() {
  if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
  rg --files-with-matches --no-messages "$1" | fzf --preview "bat --style=numbers --color=always --highlight-line {2} {} 2>/dev/null || rg --ignore-case --pretty --context 10 '$1' {}"
}