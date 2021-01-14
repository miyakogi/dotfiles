#!/usr/bin/env zsh
# Should be executed by kitty with remote control enabled
# Ex: `kitty --title kitty-music /path/to/kitty-music.sh`

kitty @ launch --title ncmpcpp ncmpcpp
kitty @ launch --title mpdcover mpdcover
kitty @ launch --title cava cava
kitty @ resize-window --match title:ncmpcpp --increment 45
