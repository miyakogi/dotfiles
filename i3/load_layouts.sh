#!/usr/bin/env bash

ws_dir=${XDG_CONFIG_HOME:-$HOME/.config}/i3/workspaces

for i in `seq 1 10`; do
  if [[ -f ${ws_dir}/workspace_$i.json ]]; then
    i3-msg "workspace $i; append_layout ${ws_dir}/workspace_$i.json"
  fi
done

exec_if_possible() {
  if type $1 &>/dev/null; then
    ($@ &)
  fi
}

exec_if_possible discord
exec_if_possible /usr/lib/firefox/firefox -p game --class="firefox-game"
exec_if_possible /usr/lib/firefox/firefox -p dev --class="firefox-dev"
