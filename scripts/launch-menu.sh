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
elif which st >/dev/null 2>&1; then
  # use st if possible on X11
  termcmd="st -e"
  cmd+=(
    st
    -f "Fira Code Medium:pixelsize=18:antialias=true"  # font
    -g "80x33"  # geometry
    -c "sklauncher"  # class name
    -e
  )
else
  # use alacritty
  termcmd="alacritty -e"
  cmd+=(
    alacritty
    --class "sklauncher,sklauncher"
    --option window.startup_mode="Windowed"
    --option window.dimensions.columns=48
    --option window.dimensions.lines=24
    --option font.normal.family="Fira Code"
    --option font.normal.style="Medium"
    --option font.size=18
    --command
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
