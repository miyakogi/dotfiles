#!/usr/bin/env bash

if is-4k; then
  workspaces=(
    "1:一"
    "2:二"
    "3:三"
    "4:四"
    "5:五"
    "6:六"
    "7:七"
    "8:八"
    "9:九"
    "10:十"
  )
else
  workspaces=(
    "11:一"
    "12:二"
    "13:三"
    "14:四"
    "15:五"
    "16:六"
    "17:七"
    "18:八"
    "19:九"
    "20:十"
  )
fi

current_workspaces="$(swaymsg -t get_workspaces | jq '.[] | .name')"
for i in "${workspaces[@]}"; do
  echo "$i"
  exist=false
  for _ws_name in $current_workspaces; do
    ws_name="$(echo "$_ws_name" | tr -d '"')"
    echo "$ws_name"
    if [ "$i" = "$ws_name" ]; then
      exist=true
      break
    fi
  done
  if [ "$exist" = false ]; then
    swaymsg workspace "$i"
    break
  fi
done
