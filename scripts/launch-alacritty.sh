#!/usr/bin/env bash

# Luanch alacritty terminal with different font size according to output name

if [[ $(swaymsg -t get_outputs | jq '.[]  | select(.focused) | .name') == '"DP-1"' ]]; then
  alacritty --option=font.size=22.5 --option=window.padding.x=12 --option=window.padding.y=12
else
  alacritty
fi
