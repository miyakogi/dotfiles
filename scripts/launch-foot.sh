#!/usr/bin/env bash

# Luanch foot terminal with different font size according to output name

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--override=font="IBM Plex Mono:size=21.0" --override=pad=12x12)
fi

foot "${options[@]}" "$@"
