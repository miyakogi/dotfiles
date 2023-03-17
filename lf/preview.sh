#!/usr/bin/bash

file=$1
w=$2
h=$3
x=$4
y=$5

mimetype="$(file -Lb --mime-type "$file")"

# Image preview requires `convert` command and must be run on kitty terminal
if [[ $TERM = *kitty* ]] && type convert &>/dev/null; then
  case "$mimetype" in
    image/*)
      kitty +icat --silent --transfer-mode file --place "${w}x${h}@${x}x${y}" "$file"
      exit 1
      ;;
    video/*)
      image_cache_dir="$HOME/.cache/lf"
      if [ ! -e "$image_cache_dir" ]; then
        mkdir -p "$image_cache_dir"
      fi
      image_cache="$image_cache_dir/$(du -b "$file" | md5sum - | cut -d ' ' -f1).png"
      if [ ! -f "$image_cache" ]; then
        ffmpegthumbnailer -s0 -i "$file" -o "$image_cache"
      fi
      kitty +icat --silent --transfer-mode file --place "${w}x${h}@${x}x${y}" "$image_cache"
      exit 1
      ;;
  esac
fi

if [[ "$mimetype" = text/* ]]; then
  bat --plain --paging=never --color=always -- "$file"
  exit 1
fi

size=$(du -h "$file" | cut -d $'\t' -f 1)
filetype=$(file "$file" | sed -r 's/^.*:\s+(.+)$/\1/g')
echo -e "\e[1;36mFile Type:\e[m $filetype\n\e[1;36mSize:\e[m $size"
