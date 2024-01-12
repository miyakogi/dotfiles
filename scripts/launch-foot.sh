#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()

if ! is-4k; then
  # FHD monitor
  fontsize="10.5"
  options+=(
    --override=pad="6x0 center"
  )
elif [ "$XDG_CURRENT_DESKTOP" = "sway" ]; then
  # no scaling 4K monitor
  fontsize="15.0"
else
  # scaled 4K monitor (Hyprland)
  fontsize="12.0"
fi

options+=(
  --override=font="MonaspiceNe Nerd Font:size=$fontsize"
  --override=font-italic="MonaspiceRn Nerd Font:size=$fontsize"
  --override=font-bold="MonaspiceNe Nerd Font:weight=800:size=$fontsize"
  --override=font-bold-italic="MonaspiceRn Nerd Font:weight=800:size=$fontsize"
)

foot "${options[@]}" "$@"
