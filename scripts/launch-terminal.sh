#!/usr/bin/env zsh

if grep "gaps" ${XDG_CONFIG_HOME:-$HOME/.config}/i3/config > /dev/null; then
  env DROPDOWN=1 kitty --override window_padding_width=0 &
else
  kitty &
fi

sleep 0.3
xdotool key Muhenkan
