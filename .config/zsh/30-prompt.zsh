autoload -U colors && colors

parse_git_branch() {
  local branch=$(git branch --show-current 2>/dev/null)
  [[ -n $branch ]] && echo "%F{green}$branch%f"
}

pre_cmd() {
  local dir_color

  case "$PWD" in
    *production*|*prod*) dir_color="red" ;;
    *staging*|*stg*)     dir_color="yellow" ;;
    *)                  dir_color="cyan" ;;
  esac

  PROMPT="$(parse_git_branch)
%{$fg[$dir_color]%}%~ %{$reset_color%}
%{$fg[red]%}> %{$reset_color%}"
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd pre_cmd

