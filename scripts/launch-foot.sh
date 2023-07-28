#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()
if [ "$(is-4k)" = false ]; then
  options+=(
    --override=font="JetBrainsMono Nerd Font:size=12.0"
    --override=font-bold="JetBrainsMono NF SemiBold:size=12.0"
    --override=pad=8x8
  )
fi

foot "${options[@]}" "$@"
