ZSH_CONFIG_DIR="$HOME/.config/zsh/"

if [ -d "$ZSH_CONFIG_DIR" ]; then
  for file in "$ZSH_CONFIG_DIR"/*.zsh; do
    [ -r "$file" ] && source "$file"
  done
fi

