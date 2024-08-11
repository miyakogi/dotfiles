#!/usr/bin/env bash

if ! type hyprlock &>/dev/null; then
  echo "\`hyprlock\` should be installed to lock screen"
  exit 1
fi

cmd=(
  hyprlock
)

"${cmd[@]}" &
