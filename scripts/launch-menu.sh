#!/usr/bin/env bash

if ! type sklauncher &>/dev/null; then
  notify-send -i system-error -u critical "ERROR" "Need \`sklauncher\` to be installed for application launcher"
fi

declare -a cmd=()

# set terminal command and options
termcmd="terminal"

cmd+=(
  terminal
  --class "sklauncher"
)

# set launcher command and options
cmd+=(
  -e
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
