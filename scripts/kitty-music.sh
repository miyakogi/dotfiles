#!/usr/bin/env zsh
kitty --title kitty-music --session - <<EOF
launch zsh -c ncmpcpp
launch mpdcover
launch cava
EOF
