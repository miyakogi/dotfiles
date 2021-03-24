#!/usr/bin/env zsh
# This script enables chrome's HW acceleration on both Wayland and Xorg sessions

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  session="wayland"
else
  session=$(loginctl show-session $(loginctl show-user $(whoami) -p Display --value) -p Type --value)
fi

flags=("--ignore-gpu-blocklist" "--enable-gpu-rasterization" "--enable-zero-copy")

if [[ $session == "wayland" ]]; then
  # Wayland session
  flags+=("--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer" "--ozone-platform=wayland")
else
  # Xorg session
  flags+=("--use-gl=desktop")
fi

exec google-chrome-stable $flags $@
