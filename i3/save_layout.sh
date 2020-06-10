#!/bin/zsh
if [[ -z $1 ]]; then
  echo "workspace number is required"
  exit
fi

_ws="$HOME/.config/i3/workspaces/_workspace_$1.json"
ws="$HOME/.config/i3/workspaces/workspace_$1.json"

i3-save-tree --workspace $1 > $_ws
tail -n +2 $_ws | fgrep -v '// split' | sed 's|//||g' > $ws

echo "saved layout $1 to $ws"
