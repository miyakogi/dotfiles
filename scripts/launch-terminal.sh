#!/usr/bin/env bash

##################
# list terminals
#
terminals=(
  foot
  alacritty
  kitty
  wezterm
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
if [ "$(is-4k)" = true ]; then
  hidpi=true
else
  hidpi=false
fi

# Set display specific options
if [ $hidpi = true ]; then
  font="JetBrainsMono Nerd Font 26"
else
  font="JetBrainsMono Nerd Font 16"
fi

# Define colors
# these colors may not be used - disable shellcheck warning

# shellcheck disable=SC2034
white="#a9b1d6"
# shellcheck disable=SC2034
black="#161821"
# shellcheck disable=SC2034
red="#e27878"
# shellcheck disable=SC2034
green="#b4be82"
# shellcheck disable=SC2034
yellow="#e2a478"
# shellcheck disable=SC2034
blue="#84a0c6"
# shellcheck disable=SC2034
magenta="#a093c7"
# shellcheck disable=SC2034
cyan="#89b8c2"

# set bemenu command options
basecolor="$cyan"
bemenu_cmd=(
  bemenu
  --prompt "Leave:"  # prompt
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
  st)
    if [ $hidpi = true ]; then
      st -f "JetBrainsMono Nerd Font:medium:size=21:antialias=true" -e fish &
    else
      st -f "JetBrainsMono Nerd Font:medium:size=12:antialias=true" -e fish &
    fi
    ;;
  alacritty)
    launch-alacritty &
    ;;
  foot)
    launch-foot &
    ;;
  kitty)
    launch-kitty &
    ;;
  wezterm)
    launch-wezterm &
    ;;
  *)
    $_terminal &
    ;;
esac
