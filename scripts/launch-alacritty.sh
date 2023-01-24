#!/usr/bin/env bash

# Luanch alacritty terminal with different font size according to output name

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--option=font.normal.style=Regular --option=font.size=24 --option=window.padding.x=12 --option=window.padding.y=12)
fi

if [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
  options+=(--option=window.opacity=0.90)
fi

alacritty "${options[@]}"
