#!/usr/bin/sh
# Generate option args for chromium-based apps to enable HW acceleration on both Wayland and Xorg

### Usage
#
# Execute this script by shell then gets option arguments in the desktop file.
#
# Example:
#   Exec=/usr/bin/google-chrome-stable $(/path/to/chromium-options.sh)
#
# On the wayland session, this script generates option args to run on Xwayland.
# If you want to use native wayland, add `wayland` option as the first argument to this script.
#
# Example:
#   Exec=/usr/bin/google-chrome-stable $(/path/to/chromium-options.sh wayland)
#

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

echo -n "${flags[@]} ${options[@]}"
