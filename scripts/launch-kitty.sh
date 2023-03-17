#!/usr/bin/env bash

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--single-instance --instance-group 'HiDPI' --override=font_size=21 --override=window_padding_width=12)
else
  options+=(--single-instance --instance-group 'FHD')
fi

kitty "${options[@]}"
