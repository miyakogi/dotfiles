#!/usr/bin/env bash

# Luanch alacritty terminal with different font size according to output name

options=()
if [ ! "$(is-4k)" = true ]; then
  options+=(--option=font.normal.style=Text --option=font.size=12.0 --option=window.padding.x=8 --option=window.padding.y=8)
fi

alacritty "${options[@]}" "$@"
