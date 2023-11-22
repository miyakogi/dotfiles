#!/usr/bin/env bash

if is-4k; then
  # workspaces='Ⅰ Ⅱ Ⅲ Ⅳ Ⅴ Ⅵ Ⅶ Ⅷ Ⅸ Ⅹ '
  workspaces=$(seq 1 10)
else
  # workspaces='① ② ③ ④ ⑤ ⑥ ⑦ ⑧ ⑨ ⑩ '
  workspaces=$(seq 11 20)
fi

# current_workspaces="$(hyprctl -j workspaces | jq '.[] | .name')"
current_workspaces="$(hyprctl -j workspaces | jq '.[] | .id')"
for i in $workspaces; do
  exist=false
  for ws_id in $current_workspaces; do
    if [ "$i" -eq "$ws_id" ]; then
      exist=true
      break
    fi
  done
  if [ "$exist" = false ]; then
    # hyprctl dispatch workspace "name:$i"
    hyprctl dispatch workspace "$i"
    break
  fi
done
