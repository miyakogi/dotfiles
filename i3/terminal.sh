#!/bin/sh

if grep "gaps" ~/.config/i3/config; then
  env DROPDOWN=1 kitty --override window_padding_width=0 &
else
  kitty &
fi
