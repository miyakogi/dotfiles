#!/usr/bin/env bash
# https://chienomi.org/articles/linux/202302-misskey-photo-compress.html

cmd=(
  pngquant
  --strip  # remove optional metadata
  --speed 1  # 1=slow & hi-quality, 11=fast & rough
  --quality 65-80  # min-max (0-100);
  -  # output to stdout
)


wl-paste | "${cmd[@]}" | wl-copy
