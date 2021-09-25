#!/usr/bin/env bash

declare -a cmd=()

# set terminal command and options
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  # use foot
  termcmd="foot"
  cmd+=(
    foot
    --font "Fira Code:size=18"
    --window-size-pixels "800x800"
    --app-id "sklauncher"
  )
else
  # use st
  termcmd="st -e"
  cmd+=(
    st
    -f "Fira Code Medium:pixelsize=18:antialias=true"  # font
    -g "80x33"  # geometry
    -c "sklauncher"  # class name
    -e
  )
fi

# set launcher command and options
if which sklauncher >/dev/null 2>&1; then
  # use `sklauncher`
  cmd+=(
    sklauncher
    --terminal-command "$termcmd"
    --match-generic-name
    --tiebreak "index"
    --exact
    --color "16,bg+:-1,border:5,pointer:3"
    --reverse
    --margin "1,2"
    --prompt " "
    --preview-window "up:3"
  )
elif which sway-launcher-desktop >/dev/null 2>&1; then
  # use `sway-launcher-desktop`
  cmd+=(
    env TERMINAL_COMMAND="$termcmd"
    env FZF_DEFAULT_OPTS="--reverse --exact"
    env GLYPH_PROMPT=" "
    sway-launcher-desktop
  )
else
  # rofi
  cmd=(
    rofi
    -show drun
  )
fi

# execute command
"${cmd[@]}"
