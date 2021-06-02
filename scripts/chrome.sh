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
  # Native wayland
  features="$features,UseOzonePlatform,WebRTCPipeWireCapturer"
  flags+=("--enable-features=$features" "--ozone-platform=wayland")
  options=("${options[2,-1]}")  # remove $1
elif [[ $session == "wayland" ]]; then
  # XWayland
  flags+=("--enable-features=$features" "--use-gl=egl")
else
  # Xorg session
  flags+=("--enable-features=$features" "--use-gl=desktop")
fi

exec google-chrome-stable "${flags[@]}" "${options[@]}"
