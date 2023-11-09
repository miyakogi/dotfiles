#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()
if [ "$(is-4k)" = false ]; then
  options+=(
    --override=font="IntoneMono Nerd Font:size=12.0"
    --override=font-bold="IntoneMono Nerd Font:weight=800:size=12.0"
    --override=pad="6x0 center"
  )
fi

foot "${options[@]}" "$@"
