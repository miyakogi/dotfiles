#!/usr/bin/env bash

# Generate option args for chromium-based apps to enable HW acceleration on both Wayland and Xorg

### Usage
#
# Execute this script by shell then gets option arguments in the desktop file.
#
# Example:
#   Exec=/usr/bin/google-chrome-stable $(/path/to/chromium-options.sh) --some-other-option
#
# On the wayland session, this script generates option args to run on Xwayland.
# If you want to use native wayland, add `wayland` option as the first argument to this script.
#
# Example:
#   Exec=/usr/bin/google-chrome-stable $(/path/to/chromium-options.sh wayland) --some-other-option
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

# Some popups (like discord settings) are collapsed by enabling RawDraw feature with AMD-enabled ffmpeg
# This bug will be fixed on v99, but we need to disable RawDraw feature on current stable (v97)
features="VaapiVideoDecoder,CanvasOopRasterization,EnableDrDc"

if [[ $1 == "wayland" ]]; then
  # --- Native Wayland --- #
  # Broken on chromium v97 with sway 1.7rc
  # -> Fixed on chromium v99

  # Enabel pipewire for RTC support
  features="$features,WebRTCPipeWireCapturer"
  # Enable RawDraw since wayland can be only enabled on versions above v99
  features="$features,RawDraw"
  # # Vulkan does not support WebGL, WebGL2, and some compositing HW accelerations now (v99)
  # features="$features,Vulkan"

  flags+=(
    --enable-features="$features"
    --ozone-platform-hint=wayland
    --ozone-platform=wayland

    # Necessary to enable fcitx5 (v99)
    # see: https://www.reddit.com/r/swaywm/comments/rwqo1d/yesterdays_chrome_97_stable_release_has_gtk4_im/
    --gtk-version=4
  )
else
  if [[ $session == "wayland" ]]; then
    # --- Xwayland --- #
    # Vulkan renderer + EGL results in unstable and slow fps (~10)
    # So disable EGL and use ANGLE
    flags+=(
      # Vulkan can be used on Xwayland
      --enable-features="$features,Vulkan"

      # Force to use ANGLE to fix Xwayland issues, especially on NVIDIA GPU (but also useful on AMD GPU)
      # See https://wiki.archlinux.org/title/chromium#Running_on_XWayland
      # Note: Vulkan backend for ANGLE is broken on electron with AMD-enabled ffmpeg, so use GL backend
      # --use-angle=gl
      # -> Update: switching from ffmpeg-amd-full to ffmpeg-vaapi (not enable vulkan) seems to fix this issue
      --use-angle=vulkan
      --use-cmd-decoder=passthrough
    )
  else
    # --- Xorg --- #
    flags+=(
      # Vulkan breaks video playback on Xorg
      --enable-features="$features"

      # Both vulkan and gl backends for ANGLE is broken on Xorg with AMD-enabled ffmpeg
      # EGL is broken on Xwayland, but works on Xorg without Vulkan
      --use-gl=egl
    )
  fi
fi

echo -n "${flags[@]}"
