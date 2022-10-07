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
white="#cdd6f4"
# shellcheck disable=SC2034
black="#1e1e2e"
# shellcheck disable=SC2034
red="#f38ba8"
# shellcheck disable=SC2034
green="#a6e3a1"
# shellcheck disable=SC2034
yellow="#f9e2af"
# shellcheck disable=SC2034
blue="#89b4fa"
# shellcheck disable=SC2034
magenta="#f5c2e7"
# shellcheck disable=SC2034
cyan="#94e2d5"

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
