#!/usr/bin/env bash
# This script enables chrome's HW acceleration on both Wayland and Xorg sessions

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  session="wayland"
else
  session=$(loginctl show-session $(loginctl show-user $(whoami) -p Display --value) -p Type --value)
fi

flags=(
  --enable-accelerated-video
  --enable-accelerated-video-decoder
  --ignore-gpu-blocklist
  --enable-gpu-rasterization
  --enable-zero-copy
  --use-gl=egl
)
features="VaapiVideoDecoder,Vulkan"
options=("$@")

if [[ $1 == "wayland" ]]; then
  # Native wayland
  features="$features,WebRTCPipeWireCapturer"
  flags+=(
    --enable-features="$features"
    --disable-features="Vulkan"
    --ozone-platform=wayland
  )
  options=("${options[2,-1]}")  # remove first option ($1)
else
  flags+=(--enable-features="$features")
fi

exec google-chrome-stable "${flags[@]}" "${options[@]}"
