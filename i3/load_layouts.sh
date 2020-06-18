#!/bin/zsh

ws_dir="$HOME/.config/i3/workspaces"

for i in `seq 1 10`; do
  if [[ -f ${ws_dir}/workspace_$i.json ]]; then
    i3-msg "workspace $i; append_layout ${ws_dir}/workspace_$i.json"
  fi
done

function exec_if_possible() {
  if which $1 >/dev/null; then
    ($1 &)
  fi
}

exec_if_possible google-chrome-stable
exec_if_possible discord
exec_if_possible glava
