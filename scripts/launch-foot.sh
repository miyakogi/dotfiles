#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()
if ! is-4k; then
  options+=(
    --override=font="MonaspiceNe Nerd Font:size=10.5"
    --override=font-italic="MonaspiceRn Nerd Font:size=10.5"
    --override=font-bold="MonaspiceNe Nerd Font:weight=800:size=10.5"
    --override=font-bold-italic="MonaspiceRn Nerd Font:weight=800:size=10.5"
    --override=pad="6x0 center"
  )
fi

foot "${options[@]}" "$@"
