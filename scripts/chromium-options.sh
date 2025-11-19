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

if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" == "wayland" ]; then
  session="wayland"
else
  session="$(loginctl show-session "$(loginctl show-user "$(whoami)" -p Display --value)" -p Type --value)"
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

  # Need to enable HW accelerated video playback (at least currently working on Xorg)
  #--disable-features="UseChromeOSDirectVideoDecoder"
  --disable-features="TabGroupsSave"  # see: https://note.com/chappy_gbf/n/n77d1439b303f

  # Initialize and enable Vulkan support
  # With only this flag, Vulkan compositing and rasterization are not selected/used
  # To really enable Vulkan, add `Vulkan` in --enable-features list
  --use-vulkan

  # see: https://note.com/chappy_gbf/n/n77d1439b303f
  #--enable-quic
  #--enable-experimental-web-platform-features
  --enable-parallel-downloading
)

# --- Define Default Features ---
# Enable VA-API acceleration for both video encoding/decoding
features="VaapiVideoEncoder,VaapiVideoDecoder,AcceleratedVideoEncoder,VaapiVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxGL"
# Enable Canvas out-of-process rasterization
features="$features,CanvasOopRasterization"
# Enable Direct Rendering Display Compositor
features="$features,EnableDrDc"
# RawDraw issues are maybe fixed at least on v99
# -> still broken on YouTube overlay
#features="$features,RawDraw"

# Need to enable HW accelerated video playback
d_features="UseChromeOSDirectVideoDecoder"

# --- Set Platform Specific Features/Flags ---
if [ "$1" = "wayland" ]; then
  # Enable pipewire support for WebRTC screen sharing
  features="$features,WebRTCPipeWireCapturer"
  # Vulkan does not support WebGL, WebGL2, and some compositing HW accelerations now (v98/v99)
  # -> --disablie-gpu-driver-bug-workarounds does not fix this

  if [ "$2" = "vulkan" ]; then
    features="$features,Vulkan,VaapiIgnoreDriverChecks,VulkanFromANGLE,DefaultANGLEVulkan"
    flags+=(
      --use-gl=angle
      --use-angle=vulkan
    )
  fi

  d_features="$d_features,UseSkiaRenderer"

  flags+=(
    --enable-features="$features"
    --disable-features="$d_features"

    # Native gpu memory buffers are enabled on wayland by default,
    # but this flag enables some more gpu memory access
    --enable-native-gpu-memory-buffers

    # Enable native Wayland support
    --ozone-platform-hint=wayland
    --ozone-platform=wayland
    --enable-wayland-ime

    # EGL seems to be the best option for now (v98)
    #--use-gl=egl
    --disable-gpu-driver-bug-workaround

    # Necessary to enable fcitx5 (v98+)
    # see: https://www.reddit.com/r/swaywm/comments/rwqo1d/yesterdays_chrome_97_stable_release_has_gtk4_im/
    # --gtk-version=4
  )
else
  # Vulkan breaks rendering on ShinyColors (v99)
  #features="$features,Vulkan"

  flags+=(
    # Native gpu memory buffers are disabled on Xorg/Xwayland by default
    # -> this breaks flatpak version (v103)
    --enable-native-gpu-memory-buffers
  )

  if [ "$session" == "wayland" ]; then
    # --- Xwayland --- #
    flags+=(
      --enable-features="$features"

      # EGL renders in low FPS (10~20fps)
      #--use-gl=desktop
      # -> fixed by mesa's MR !15381 (not merged into main yet)
      # -> on flatpak version, can't use system mesa, so this MR is not included
      #--use-gl=egl

      # Windowing by GTK4
      --gtk-version=4
    )
  else
    # --- Xorg --- #
    flags+=(
      --enable-features="$features"

      # Fcitx5 does not work on GTK4
      # --gtk-version=4
    )
  fi
fi

# --- Output All Flags/Features ---
for flag in "${flags[@]}"; do
  echo "$flag"
done
