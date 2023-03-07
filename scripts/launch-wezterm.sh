#!/usr/bin/env bash

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--config=font_size=21)
fi

if [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
  options+=(--config=window_background_opacity=0.9)
fi

wezterm "${options[@]}"
