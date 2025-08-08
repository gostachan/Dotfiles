alias rm='trash'

# zed
alias zed="open -a /Applications/Zed.app"
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# prompt
autoload -U colors && colors

parse_git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  [[ -n $branch ]] && echo "%F{green}$branch%f"
}

pre_cmd() {
  local dir_color
 
  case "$PWD" in
    *production*|*prod*)
      dir_color="red"
      ;;
    *staging*|*stg*)
      dir_color="yellow"
      ;;
    *)
      dir_color="cyan"
      ;;
  esac
 
  PROMPT="$(parse_git_branch)
%{$fg[$dir_color]%}%~ %{$reset_color%}
%{$fg[red]%}> %{$reset_color%}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd pre_cmd



# docker
alias di="docker image"
alias dc="docker compose"
alias de="docker exec -it"
alias dl="docker logs -f"
alias dp="docker ps"

# git
alias ga='git add'
alias gb='git branch'
alias gc='git commit -m'
alias gd='git diff'
alias gl='git log'
alias gm='git merge'
alias gst='git status'
alias gsw='git switch'
alias gpl='git pull'
alias gps='git push'

# tmux
alias t='tmux'
alias tl='tmux ls'
alias ta='tmux a'
alias tat='tmux a -t'
alias tks='tmux kill-server'
alias trst='tmux rename-session -t'
tsw() {
  if [[ $# -eq 1 ]]; then
    local target="$1"
    local current
    current=$(tmux display-message -p '#I' 2>/dev/null)

    if [[ -z "$current" ]]; then
      echo "Not inside a tmux session."
      return 1
    fi

    if [[ "$current" == "$target" ]]; then
      return 0
    fi

    tmux swap-window -s "$current" -t "$target"
    tmux select-window -t "$target"

  elif [[ $# -eq 2 ]]; then
    local win1="$1"
    local win2="$2"

    tmux swap-window -s "$win1" -t "$win2"
    tmux select-window -t "$win2"

  else
    echo "Usage: tsw <target-index> OR tsw <index1> <index2>"
    return 1
  fi
}

# vim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'
alias vv='nvim'
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"


# cargo & rust
alias carb='cargo build'
alias carc='cargo check'
alias carn='cargo new'
alias carr='cargo run'

alias ron='rustup override set nightly'

# php
export PATH="$HOME/.phpenv/bin:$PATH"
eval "$(phpenv init -)"

# laravel
export PATH="/Users/haramisaki/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/haramisaki/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"

# mysql
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"

# cpp
alias gpp='g++ -std=c++20'

# terraform
alias ter="terraform"

terraform() {
  if [[ "$PWD" == *"production"* || "$PWD" == *"prod"* ]]; then
    echo "   You are in the production environment! Do NOT run terraform commands here."
    echo "If you really need to run it, use terraform-prod instead."
    return 1
  else
    command terraform "$@"
  fi
}

terraform-prod() {
  echo "🚨 Warning! You are about to run terraform in the production environment!"
  read "answer?Are you sure you want to continue? (yes/no): "

  if [[ "$answer" != "yes" ]]; then
    echo "❌ Cancelled."
    return 1
  fi

  command terraform "$@"
}


# etc
alias reboot_ghostty='killall ghostty && open -a ghostty'
alias mkdir='mkdir -p'
alias rmds="find . -name '.DS_Store' -type f -delete"
alias uddf="~/dotfiles/.bin/install.sh"
alias lls="(ls -al --color=always | grep '^d' | sort) && (ls -al --color=always | grep -v '^d' | sort)"

#edit
alias ezsh='nvim ~/.zshrc && source ~/.zshrc'
alias etmux='vim ~/.tmux.conf && tmux display-message "Reloaded tmux.conf" && tmux source-file ~/.tmux.conf'
alias evim='
cd ~/dotfiles/.config/nvim
vim ~/dotfiles/.config/nvim
cd -
'
