#!/usr/bin/env bash

declare -a cmd=()

# set terminal command and options
if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  # use foot
  termcmd="foot"
  if [[ $XDG_CURRENT_DESKTOP == "sway" ]]; then
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
  fi
  cmd+=(
    foot
    --font "${_font}:weight=${_weight}:size=${_fsize}"
    --window-size-pixels "$winsize"
    --app-id "sklauncher"
  )
elif type st &>/dev/null; then
  # use st if possible on X11
  termcmd="st -e"
  cmd+=(
    st
    -f "Fira Code Medium:pixelsize=22:antialias=true"  # font
    -g "48x28"  # geometry
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
if type sklauncher &>/dev/null; then
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
elif type sway-launcher-desktop &>/dev/null; then
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
