#!/usr/bin/env bash

# Luanch alacritty terminal with different font size according to output name

if [[ $(swaymsg -t get_outputs | jq '.[]  | select(.focused) | .name') == '"DP-1"' ]]; then
  kitty --single-instance --instance-group 'HiDPI' --override=font_size=22.5 --override=window_padding_width=12
else
  kitty --single-instance --instance-group 'FHD'
fi
