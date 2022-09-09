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

# Define colors
# these colors may not be used - disable shellcheck warning

# shellcheck disable=SC2034
white="#edf0f5"
# shellcheck disable=SC2034
black="#282828"
# shellcheck disable=SC2034
red="#e64e42"
# shellcheck disable=SC2034
green="#48d684"
# shellcheck disable=SC2034
yellow="#f9a55b"
# shellcheck disable=SC2034
blue="#00ad9f"
# shellcheck disable=SC2034
magenta="#9059c8"
# shellcheck disable=SC2034
cyan="#6699ee"

# set dispaly specific options
if [[ $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name') == '"DP-1"' ]]; then
  font="Fira Code 30"
else
  font="Fira Code 16.5"
fi

# set bemenu command options
bemenu_cmd=(
  bemenu
  --prompt "$prompt"  # prompt
  --fn "$font"  # font
  --tb "$cyan"   # title background color
  --tf "$black"  # title foreground color
  --fb "$black"  # filter background color
  --ff "$white"  # filter foreground color
  --nb "$black"  # normal background color
  --nf "$white"  # normal foreground color
  --hb "$cyan"   # selected background color
  --hf "$black"  # selected foreground color
  --sb "$cyan"   # selected background color
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
    $_terminal -e fish &
    ;;
  foot)
    launch-foot &
    ;;
  *)
    $_terminal &
    ;;
esac
