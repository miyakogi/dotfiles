#!/usr/bin/env bash

options=()
if ! is-4k; then
  options+=(
    --override=font_size=13.5
    --override=window_padding_width=4
    --override=window_border_width=2px
  )
fi

# Fixing driver improve startup time
kitty "${options[@]}" "$@"
