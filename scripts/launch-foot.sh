#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

if [[ $(swaymsg -t get_outputs | jq '.[]  | select(.focused) | .name') == \"DP-1\" ]]; then
  footclient --override=font="Sarasa Term J:weight=Light:size=22.5" --override=pad=12x12
else
  footclient
fi
