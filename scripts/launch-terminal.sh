#!/usr/bin/env bash

##################
# list terminals
#
list_terminals() {
  terminals=(
    foot
    alacritty
    kitty
    havoc
    wezterm
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
if is-4k; then
  font="Moralerspace Argon NF 20"
else
  font="Moralerspace Argon NF 16"
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
  *)
    $_terminal &
    ;;
esac
