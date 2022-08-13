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
  terminals=(${terminals[@]} st)
fi

list_terminals() {
  for t in ${terminals[@]}; do
    echo " $t "
  done
}

#####################
# bemenu/dmenu setup
#
prompt="Launch Terminal:"

# define colors
white="#c3c7d1"
black="#161925"
red="#ed254e"
green="#00e8c6"
yellow="#f9dc5c"
blue="#7cb7ff"
magenta="#c74ded"
cyan="#00c1e1"

# set dispaly specific options
if [[ $(swaymsg -t get_outputs | jq '.[] | select(.focused) | .name') == '"DP-1"' ]]; then
  font="Fira Code 28"
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
