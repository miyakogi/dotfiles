#!/bin/sh

term=kitty
term_class=scratchkitty

wid=$(xdotool search --class $term_class)
if [[ -z $wid ]]; then
  env DROPDOWN=0 $term --class $term_class --override background_opacity=0.7 --override window_padding_width=0 &
  wid=`xdotool search --sync --class $term_class`
  if [[ -z $1 ]]; then
    bspc node $wid --flag hidden -f
  fi
else
  if [[ `xdotool getactivewindow` -eq $wid ]]; then
    bspc node $wid --flag hidden -f
  else
    if [[ ! `xdotool search --onlyvisible --class $term_class` ]]; then
      bspc node $wid --flag hidden -f
    fi
    xdotool search --class $term_class windowactivate
  fi
fi
