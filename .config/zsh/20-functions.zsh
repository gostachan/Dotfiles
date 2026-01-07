# tmux window swap
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

# terraform safety
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

