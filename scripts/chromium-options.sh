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

# --- Define Default Flags ---
flags=(
  # Force GPU Acceleration
  # see https://wiki.archlinux.org/title/Chromium#Force_GPU_acceleration
  --ignore-gpu-blocklist
  --enable-gpu-rasterization
  --enable-zero-copy

  # Out of process rasterization for the rendering on GPU
  --enable-oop-rasterization

  # Initialize and enable Vulkan support
  # With only this flag, Vulkan compositing and rasterization are not selected/used
  # To really enable Vulkan, add `Vulkan` in --enable-features list
  --use-vulkan

  # EGL seems to be the best option for now (v98)
  --use-gl=egl
)

# --- Define Default Features ---
# Enable VA-API acceleration for both video encoding/decoding
features="VaapiVideoEncoder,VaapiVideoDecoder"
# Enable Canvas out-of-process rasterization
features="$features,CanvasOopRasterization"
# Enabel Direct Rendering Display Compositor
features="$features,EnableDrDc"
# Some popups (like discord settings) are collapsed by enabling RawDraw feature with AMD-enabled ffmpeg
# This bug will be fixed on v99, but we need to disable RawDraw feature on current stable (v97)
# -> RawDraw still has some issues on native Wayland on v98
#features="$features,RawDraw"

# --- Set Platform Specific Features/Flags ---
if [[ $1 == "wayland" ]]; then
  # Enable pipewire support for WebRTC screen sharing
  features="$features,WebRTCPipeWireCapturer"
  # Enable RawDraw since wayland can be only enabled on versions above v98
  # -> RawDraw still does not render some popups correctly, so disabled (v98)
  #features="$features,RawDraw"
  # Vulkan does not support WebGL, WebGL2, and some compositing HW accelerations now (v98/v99)
  # -> --disablie-gpu-driver-bug-workarounds does not fix this
  #features="$features,Vulkan"

  flags+=(
    --enable-features="$features"

    # Enable native Wayland support
    --ozone-platform-hint=wayland
    --ozone-platform=wayland

    # Necessary to enable fcitx5 (v98+)
    # see: https://www.reddit.com/r/swaywm/comments/rwqo1d/yesterdays_chrome_97_stable_release_has_gtk4_im/
    --gtk-version=4
  )
else
  # Vulkan is necessary to use EGL on Xwayland/Xorg
  # Without Vulkan, browser shows very slow fps
  features="$features,Vulkan"
  # RawDraw is maybe working fine on Xwayland/Xorg (v98+)
  features="$features,RawDraw"

  if [[ $session == "wayland" ]]; then
    # --- Xwayland --- #
    flags+=(
      --enable-features="$features"

      # EGL works fine on gtk4
      --gtk-version=4
    )
  else
    # --- Xorg --- #
    flags+=(
      --enable-features="$features"

      # Fcitx5 does not work on GTK4
      #--gtk-version=4
    )
  fi
fi

# --- Output All Flags/Features ---
echo -n "${flags[@]}"
