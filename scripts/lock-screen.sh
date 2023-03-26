#!/usr/bin/env bash

if ! type waylock &>/dev/null; then
  echo "\`waylock\` should be installed to lock screen"
  exit 1
fi

cmd=(
  waylock
  -fork-on-lock  # fork and go to the background
  -init-color 0x161821  # black: default background color
  -input-color 0x84a9c6  # blue: background color while typing password
  -fail-color 0xe9b189  # red: background color when password is incorrect
)

"${cmd[@]}"
