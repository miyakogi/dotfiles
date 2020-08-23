#!/bin/sh

if grep "gaps" ~/.config/i3/config >/dev/null; then
  xoffset=16
  yoffset=16
  theme=menu-theme-gaps
else
  xoffset=0
  yoffset=12
  theme=menu-theme
fi

rofi -show drun \
  -theme $theme \
  -xoffset $xoffset \
  -yoffset $yoffset
