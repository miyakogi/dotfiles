#!/usr/bin/env bash

# Luanch alacritty terminal with different font size according to output name

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--option=font.normal.style=Text --option=font.size=21.0 --option=window.padding.x=12 --option=window.padding.y=12)
fi

alacritty "${options[@]}" "$@"
