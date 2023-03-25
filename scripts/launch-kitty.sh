#!/usr/bin/env bash

options=()
if [ "$(is-4k)" = true ]; then
  options+=(--override=font_size=21 --override=window_padding_width=12 --override=window_border_width=4)
fi

# Fixing driver improve startup time
# see: https://sw.kovidgoyal.net/kitty/faq/#why-does-kitty-sometimes-start-slowly-on-my-linux-system
env MESA_LOADER_DRIVER_OVERRIDE=radeonsi __EGL_VENDOR_LIBRARY_FILENAMES=/usr/share/glvnd/egl_vendor.d/50_mesa.json kitty "${options[@]}"
