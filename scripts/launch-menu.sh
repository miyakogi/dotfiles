#!/usr/bin/env bash

if ! type sklauncher &>/dev/null; then
  notify-send -i system-error -u critical "ERROR" "Need \`sklauncher\` to be installed for application launcher"
fi

declare -a cmd=()

# set terminal command and options
termcmd="$TERMINAL"

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
  alacritty
  --class "sklauncher"
  --option "font.size=${_fsize}"
  --option "window.opacity=1.0"
  --option "window.startup_mode='Windowed'"
  --option "window.dimensions.columns=60"
  --option "window.dimensions.lines=30"
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
