#!/usr/bin/env zsh

if grep -q "gaps" ${XDG_CONFIG_HOME:-$HOME/.config}/i3/config; then
  xoffset=12
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
