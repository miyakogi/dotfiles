#!/usr/bin/env bash

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--config=font_size=21.0)
fi

wezterm "${options[@]}"
