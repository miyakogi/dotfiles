#!/usr/bin/env bash

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--override=font_size=21 --override=window_padding_width=12 --override=window_border_width=4)
fi

# Fixing driver improve startup time
kitty "${options[@]}"
