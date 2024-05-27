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
  fontsize="12.0"
else
  # scaled 4K monitor (Hyprland)
  fontsize="12.0"
fi

options+=(
  --override=font="Moralerspace Neon NF:size=$fontsize"
  --override=font-italic="Moralerspace Radon NF:size=$fontsize"
  --override=font-bold="Moralerspace Neon NF:weight=800:size=$fontsize"
  --override=font-bold-italic="Moralerspace Radon NF:weight=800:size=$fontsize"
)

footclient "${options[@]}" "$@"
