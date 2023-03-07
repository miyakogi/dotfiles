#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--override=font="JetBrainsMono Nerd Font:size=21" --override=pad=12x12)
fi

if [ "$XDG_CURRENT_DESKTOP" = Hyprland ]; then
  options+=(--override=colors.alpha=0.90)
fi

foot "${options[@]}"
