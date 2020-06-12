#!/bin/zsh

ws_dir="$HOME/.config/i3/workspaces"

if [[ -f ${ws_dir}/workspace_1.json ]]; then
  i3-msg "workspace 1; append_layout ${ws_dir}/workspace_1.json"
fi

if [[ -f ${ws_dir}/workspace_2.json ]]; then
  i3-msg "workspace 2; append_layout ${ws_dir}/workspace_2.json"
fi

if [[ -f ${ws_dir}/workspace_10.json ]]; then
  i3-msg "workspace 10; append_layout ${ws_dir}/workspace_10.json"
fi

function exec_if_possible() {
  if which $1 >/dev/null; then
    ($1 &)
  fi
}

if which transparent >/dev/null; then
  (transparent &)
else
  ($HOME/.config/i3/transparent.py &)
fi

exec_if_possible google-chrome-stable
exec_if_possible discord
exec_if_possible cantata
