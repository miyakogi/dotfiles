#!/usr/bin/env bash
# This script enables chrome's HW acceleration on both Wayland and Xorg sessions

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  session="wayland"
else
  session=$(loginctl show-session $(loginctl show-user $(whoami) -p Display --value) -p Type --value)
fi

flags=(
  # Enable HW video acceleration
  --enable-accelerated-video
  --enable-accelerated-video-decoder
  # Force GPU Acceleration
  # see https://wiki.archlinux.org/title/Chromium#Force_GPU_acceleration
  --ignore-gpu-blocklist
  --enable-gpu-rasterization
  --enable-zero-copy
)
features="VaapiVideoDecoder,CanvasOopRasterization,EnableDrDc,RawDraw"
options=("$@")

if [[ $1 == "wayland" ]]; then
  # Native wayland
  features="$features,WebRTCPipeWireCapturer"
  flags+=(
    --enable-features="$features"
    --ozone-platform=wayland
  )
  options=("${options[2,-1]}")  # remove first option ($1)
else
  features="$features,Vulkan"
  flags+=(
    --enable-features="$features"
  )
  if [[ $session == "wayland" ]]; then
    # Xwayland
    flags+=(
      # Force to use ANGLE to fix Xwayland issues, especially on NVIDIA GPU (but also useful on AMD GPU)
      # see https://wiki.archlinux.org/title/chromium#Running_on_XWayland
      --use-angle=vulkan
      --use-cmd-decoder=passthrough
    )
  else
    # Xorg
    flags+=(
      # GL is broken on Xwayland
      --use-gl=egl
    )
  fi
fi

exec google-chrome-stable "${flags[@]}" "${options[@]}"
