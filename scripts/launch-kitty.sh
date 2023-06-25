#!/usr/bin/env bash

options=()
if [ ! "$(is-4k)" = true ]; then
  options+=(
    --override=font_size=12.0
    --override=window_padding_width=8
    --override=window_border_width=2px
  )
fi

# Fixing driver improve startup time
kitty "${options[@]}" "$@"
