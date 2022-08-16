#!/usr/bin/env bash

if ! type foot &>/dev/null; then
  notify-send -i system-error -u critical "ERROR" "Need `foot` to be installed for application launcher"
fi

if ! type sklauncher &>/dev/null; then
  notify-send -i system-error -u critical "ERROR" "Need `sklauncher` to be installed for application launcher"
fi

declare -a cmd=()

# set terminal command and options
# use foot
termcmd="foot"

# set output specific options
_font="Sarasa Term J"
if [[ $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name') == '"DP-1"' ]]; then
  _fsize=28
  _weight="light"
  winsize="1600x1600"
else
  _fsize=16
  _weight="regular"
  winsize="800x800"
fi

cmd+=(
  foot
  --font "${_font}:weight=${_weight}:size=${_fsize}"
  --window-size-pixels "$winsize"
  --app-id "sklauncher"
)

# set launcher command and options
cmd+=(
  sklauncher
  --terminal-command "$termcmd"
  --match-generic-name
  --tiebreak "index"
  --exact
  --accent-color "green"
  --color "16,bg+:-1,fg+:4,prompt:4,border:4,pointer:4"
  --reverse
  --margin "1,2"
  --prompt " "
  --preview-window "up:3"
)

# execute command
"${cmd[@]}"
