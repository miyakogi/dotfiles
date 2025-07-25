#!/usr/bin/env bash

if ! type foot &>/dev/null; then
  notify-send -i system-error -u critical "ERROR" "Need \`foot\` to be installed for application launcher"
fi

if ! type sklauncher &>/dev/null; then
  notify-send -i system-error -u critical "ERROR" "Need \`sklauncher\` to be installed for application launcher"
fi

declare -a cmd=()

# set terminal command and options
# use foot
termcmd="foot"

# set output specific options
_font="monospace"
if is-4k; then
  winsize="1200x1200"
  _fsize=26
else
  winsize="960x960"
  _fsize=22
fi

cmd+=(
  foot
  --font "${_font}:size=${_fsize}"
  --window-size-pixels "$winsize"
  --app-id "sklauncher"
  --override "colors.alpha=0.70"
)

# set launcher command and options
cmd+=(
  sklauncher
  --terminal-command "$termcmd"
  # --match-generic-name
  --exact
  --tiebreak "index"
  --no-sort
  --accent-color "magenta"
  --color "16,bg+:-1,fg+:5,prompt:5,border:5,pointer:5"  # yellow-ish
  --reverse
  --margin "1,2"
  --prompt " "
  --preview-window "up:3"
)

# execute command
app2unit -- "${cmd[@]}"
