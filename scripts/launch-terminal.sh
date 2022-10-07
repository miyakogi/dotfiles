#!/usr/bin/env bash

##################
# list terminals
#
terminals=(
  foot
  alacritty
  kitty
)

if type st &>/dev/null; then
  terminals+=(st)
fi

list_terminals() {
  for t in "${terminals[@]}"; do
    echo " $t "
  done
}

#####################
# bemenu/dmenu setup
#
prompt="Launch Terminal:"

# Check display
if [[ $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name') == '"DP-1"' ]]; then
  hidpi=true
else
  hidpi=false
fi

# Set dispaly specific options
if [ $hidpi = true ]; then
  font="Fira Code 30"
else
  font="Fira Code 16.5"
fi

# Define colors
# these colors may not be used - disable shellcheck warning

# shellcheck disable=SC2034
white="#d8dee9"
# shellcheck disable=SC2034
black="#2e3440"
# shellcheck disable=SC2034
red="#bf616a"
# shellcheck disable=SC2034
green="#a3be8c"
# shellcheck disable=SC2034
yellow="#ebcb8b"
# shellcheck disable=SC2034
blue="#81a1c1"
# shellcheck disable=SC2034
magenta="#b48ead"
# shellcheck disable=SC2034
cyan="#88c0d0"

# set bemenu command options
basecolor="$cyan"
bemenu_cmd=(
  bemenu
  --prompt "$prompt"  # prompt
  --fn "$font"  # font
  --tb "$basecolor"   # title background color
  --tf "$black"  # title foreground color
  --fb "$black"  # filter background color
  --ff "$white"  # filter foreground color
  --nb "$black"  # normal background color
  --nf "$white"  # normal foreground color
  --hb "$basecolor"   # selected background color
  --hf "$black"  # selected foreground color
  --sb "$basecolor"   # selected background color
  --sf "$black"  # selected foreground color
)

cmd=("${bemenu_cmd[@]}")

#####################
# Execute
#

# choose terminal
_terminal=$( list_terminals | "${cmd[@]}" | tr -d '[:space:]' )

# modify some terminal command and launch
case $_terminal in
  st)
    if [ $hidpi = true ]; then
      st -f "Sarasa Term Nerd Font:medium:size=22.5:antialias=true" -e fish &
    else
      st -e fish &
    fi
    ;;
  foot)
    launch-foot &
    ;;
  alacritty)
    launch-alacritty &
    ;;
  *)
    $_terminal &
    ;;
esac
