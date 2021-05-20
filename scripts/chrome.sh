#!/usr/bin/env bash
# This script enables chrome's HW acceleration on both Wayland and Xorg sessions

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  session="wayland"
else
  session=$(loginctl show-session $(loginctl show-user $(whoami) -p Display --value) -p Type --value)
fi

flags=("--ignore-gpu-blocklist" "--enable-gpu-rasterization" "--enable-zero-copy" "--enable-accelerated-video-decoder")
features="VaapiVideoDecoder,Vulkan"
options=("$@")

if [[ $1 == "wayland" ]]; then
  features="$features,UseOzonePlatform,WebRTCPipeWireCapturer"
  flags+=("--ozone-platform=wayland")
  options=("${options[2,-1]}")  # remove $1
fi

if [[ $session == "wayland" ]]; then
  # Wayland session
  flags+=("--enable-features=$features")
else
  # Xorg session
  flags+=("--enable-features=$features" "--use-gl=desktop")
fi

exec google-chrome-stable "${flags[@]}" "${options[@]}"
