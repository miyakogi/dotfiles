#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()
# font="GoMono Nerd Font"
font="0xProto Nerd Font"
# font="Cascadia Code NF SemiLight"
# font_bold="Cascadia Code NF SemiBold"

if ! is-4k; then
  # FHD monitor
  fontsize="15"
else
  # scaled 4K monitor
  fontsize="15"
fi

if [ -z "$font" ]; then
  options+=(
    --override=font="Moralerspace Neon NF:size=$fontsize"
    --override=font-italic="Moralerspace Radon NF:size=$fontsize"
    --override=font-bold="Moralerspace Neon NF:weight=800:size=$fontsize"
    --override=font-bold-italic="Moralerspace Radon NF:weight=800:size=$fontsize"
  )
else
  options+=(
    --override=font="$font:size=$fontsize"
  )
  if [ -n "$font_bold" ]; then
    options+=(
      --override=font-bold="$font_bold:size=$fontsize"
    )
  fi
fi

foot "${options[@]}" "$@"
