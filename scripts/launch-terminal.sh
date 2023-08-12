#!/usr/bin/env bash

##################
# list terminals
#
list_terminals() {
  terminals=(
    foot
    alacritty
    kitty
    wezterm
    st
  )
  for t in "${terminals[@]}"; do
    if type "$t" &>/dev/null; then
      echo " $t "
    fi
  done
}

#####################
# bemenu/dmenu setup
#
# Set display specific options
if [ "$(is-4k)" = true ]; then
  font="JetBrainsMono Nerd Font 26"
  st_font="JetBrainsMono Nerd Font:medium:size=21:antialias=true"
else
  font="JetBrainsMono Nerd Font 16"
  st_font="JetBrainsMono Nerd Font:medium:size=12:antialias=true"
fi

# Define colors
# these colors may not be used - disable shellcheck warning

# shellcheck disable=SC2034
white="#bbbbbb"
# shellcheck disable=SC2034
black="#121212"
# shellcheck disable=SC2034
red="#fa2573"
# shellcheck disable=SC2034
green="#98e123"
# shellcheck disable=SC2034
yellow="#dfd460"
# shellcheck disable=SC2034
blue="#1080d0"
# shellcheck disable=SC2034
magenta="#8799ff"
# shellcheck disable=SC2034
cyan="#43a8d0"

# set bemenu command options
basecolor="$cyan"
bemenu_cmd=(
  bemenu
  --prompt "Terminal:"  # prompt
  --ignorecase
  --fn "$font"  # font
  --tb "$basecolor"   # title background color
  --tf "$black"  # title foreground color
  --fb "$black"  # filter background color
  --ff "$white"  # filter foreground color
  --nb "$black"  # normal background color
  --nf "$white"  # normal foreground color
  --hb "$basecolor"   # selected background color
  --hf "$black"  # selected foreground color
  --fbb "$black"  # feedback background color
  --fbf "$white"  # feedback foreground color
  --sb "$basecolor"   # selected background color
  --sf "$black"  # selected foreground color
  --ab "$black"   # alternating background color
  --af "$white"  # alternating foreground color
)

cmd=("${bemenu_cmd[@]}")

#####################
# Execute
#

# choose terminal
_terminal=$( list_terminals | "${cmd[@]}" | tr -d '[:space:]' )

# modify some terminal command and launch
case $_terminal in
  foot)
    launch-foot &
    ;;
  alacritty)
    launch-alacritty &
    ;;
  kitty)
    launch-kitty &
    ;;
  wezterm)
    launch-wezterm &
    ;;
  st)
    st -f "$st_font" -e fish &
    ;;
  *)
    $_terminal &
    ;;
esac
