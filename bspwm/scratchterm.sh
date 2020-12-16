#!/usr/bin/env zsh

term=kitty
term_class=scratchterm

# get window id of currently runnning dropdown terminal
wid=$(xdotool search --class $term_class)

if [[ -z $wid ]]; then
  # if dropdown terminal is not running, start it
  env DROPDOWN=1 $term --class $term_class --override background_opacity=0.7 --override window_padding_width=2 &

  # get new window id of dropdown terminal (wait until window appears)
  wid=`xdotool search --sync --class $term_class`
else
  # dropdown terminal is running
  if [[ `xdotool getactivewindow` -eq $wid ]]; then
    # currently focused on dropdown terminal, so hide it
    bspc node $wid --flag hidden -f
  else
    if [[ ! `xdotool search --onlyvisible --class $term_class` ]]; then
      # dropdown terminal is hidden, so toggle it and show
      bspc node $wid --flag hidden -f
    fi

    # focus to the dropdown terminal
    xdotool search --class $term_class windowactivate
  fi
fi
