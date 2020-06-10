#!/bin/zsh

ws_dir="$HOME/.config/i3/workspaces"

if [[ -f ${ws_dir}/workspace_1.json ]]; then
  i3-msg "workspace 1; append_layout ${ws_dir}/workspace_1.json"
fi

if [[ -f ${ws_dir}/workspace_2.json ]]; then
  i3-msg "workspace 2; append_layout ${ws_dir}/workspace_2.json"
fi

if [[ -f ${ws_dir}/workspace_9.json ]]; then
  i3-msg "workspace 9; append_layout ${ws_dir}/workspace_9.json"
fi

($HOME/.config/i3/transparent &)
(google-chrome-stable &)
(discord &)
(cantata &)
