#!/usr/bin/env zsh
# Should be executed by kitty with remote control enabled
# Ex: `kitty -T kitty-music -o allow_remote_control=yes -o enabled_layouts="*" kitty-music.sh`

kitty @ goto-layout splits
kitty @ launch --title ncmpcpp --location vsplit --keep-focus ncmpcpp
kitty @ launch --title cava --location hsplit --keep-focus cava
kitty @ launch --title mpdcover --location hsplit --keep-focus mpdcover
kitty @ resize-window --match title:ncmpcpp --increment 45
