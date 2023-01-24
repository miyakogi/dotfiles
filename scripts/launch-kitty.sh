#!/usr/bin/env bash

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--single-instance --instance-group 'HiDPI' --override=font_size=22.5 --override=window_padding_width=12)
else
  options+=(--single-instance --instance-group 'FHD')
fi

if [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
  options+=(--override=background_opacity=0.90)
fi

kitty "${options[@]}"
