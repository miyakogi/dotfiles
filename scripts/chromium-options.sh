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

if [[ -n "$WAYLAND_DISPLAY" || "$XDG_SESSION_TYPE" == "wayland" ]]; then
  session="wayland"
else
  session="$(loginctl show-session $(loginctl show-user $(whoami) -p Display --value) -p Type --value)"
fi

flags=(
  # Enable HW video acceleration
  # -> maybe enabled by default at least on v98
  #--enable-accelerated-video
  #--enable-accelerated-video-decode
  #--enable-accelerated-video-decoder

  # Force GPU Acceleration
  # see https://wiki.archlinux.org/title/Chromium#Force_GPU_acceleration
  --ignore-gpu-blocklist
  --enable-gpu-rasterization
  --enable-zero-copy
)

# Some popups (like discord settings) are collapsed by enabling RawDraw feature with AMD-enabled ffmpeg
# This bug will be fixed on v99, but we need to disable RawDraw feature on current stable (v97)
features="VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization,EnableDrDc"

if [[ $1 == "wayland" ]]; then
  # --- Native Wayland --- #
  # Broken on chrome v97 with sway 1.7
  # -> Fixed on chromium v99
  # -> Backported to chromium v97 and chrome v98

  # Enable pipewire for RTC support
  features="$features,WebRTCPipeWireCapturer"
  # Enable RawDraw since wayland can be only enabled on versions above v98
  # -> RawDraw still does not render some popups correctly, so disabled (v98)
  #features="$features,RawDraw"
  # Vulkan does not support WebGL, WebGL2, and some compositing HW accelerations now (v98/v99)
  #features="$features,Vulkan"

  flags+=(
    --enable-features="$features"
    --ozone-platform-hint=wayland
    --ozone-platform=wayland

    # EGL seems to be the best option now (v98)
    --use-gl=egl

    # Necessary to enable fcitx5 (v98~)
    # see: https://www.reddit.com/r/swaywm/comments/rwqo1d/yesterdays_chrome_97_stable_release_has_gtk4_im/
    --gtk-version=4
  )
else
  if [[ $session == "wayland" ]]; then
    # --- Xwayland --- #
    # Vulkan renderer + EGL results in unstable and slow fps (~10)
    # So disable EGL and use ANGLE
    # -> This flag seems to be fixed by gtk4 flag on v98

    # Vulkan can be used on Xwayland
    features="$features,Vulkan"
    # RawDraw works fine on Xwayland (v98)
    features="$features,RawDraw"

    # Build flags
    flags+=(
      --enable-features="$features"

      # Force to use ANGLE to fix Xwayland issues, especially on NVIDIA GPU (but also useful on AMD GPU)
      # See https://wiki.archlinux.org/title/chromium#Running_on_XWayland
      # Note: Vulkan backend for ANGLE is broken on electron with AMD-enabled ffmpeg, so use GL backend
      #--use-angle=gl
      #--use-cmd-decoder=passthrough

      # EGL works fine on gtk4
      --use-gl=egl
      --gtk-version=4
    )
  else
    # --- Xorg --- #
    flags+=(
      # Vulkan breaks video playback on Xorg
      # -> fixed on v98
      --enable-features="$features,Vulkan"
      # RawDraw works fine on Xorg (v98)
      --enable-features="$features,RawDraw"

      # Both vulkan and gl backends for ANGLE is broken on Xorg with AMD-enabled ffmpeg
      # EGL is broken on Xwayland, but works on Xorg without Vulkan
      # -> fixed on v98, both Vulkan and EGL work fine on Xorg
      --use-gl=egl

      # Fcitx5 on GTK4 does not work
      #--gtk-version=4
    )
  fi
fi

# output all flags
echo -n "${flags[@]}"
