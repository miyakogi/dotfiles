#!/usr/bin/env bash
# This script enables chrome's HW acceleration on both Wayland and Xorg sessions

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  session="wayland"
else
  session=$(loginctl show-session $(loginctl show-user $(whoami) -p Display --value) -p Type --value)
fi

flags=(
  --ignore-gpu-blocklist
  --enable-gpu-rasterization
  --enable-zero-copy
  --enable-accelerated-video-decoder
)
features="VaapiVideoDecoder,Vulkan"
options=("$@")

if [[ $1 == "wayland" ]]; then
  # Native wayland
  features="$features,UseOzonePlatform,WebRTCPipeWireCapturer"
  flags+=(
    --enable-features="$features"
    --ozone-platform=wayland
  )
  options=("${options[2,-1]}")  # remove first option ($1)
else
  flags+=(--enable-features="$features")
  if [[ $session == "wayland" ]]; then
    # XWayland
    flags+=(--use-gl=egl)
  else
    # Xorg session
    flags+=(--use-gl=desktop)
  fi
fi

exec google-chrome-stable "${flags[@]}" "${options[@]}"
