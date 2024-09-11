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
    rio
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
  font="Moralerspace Neon NF 20"
else
  font="Moralerspace Neon NF 16"
fi

# Define colors
# these colors may not be used - disable shellcheck warning

# shellcheck disable=SC2034
white="#c0caf5"
# shellcheck disable=SC2034
black="#000000"
# shellcheck disable=SC2034
red="#f7768e"
# shellcheck disable=SC2034
green="#9ece6a"
# shellcheck disable=SC2034
yellow="#e0af68"
# shellcheck disable=SC2034
blue="#7aa2f7"
# shellcheck disable=SC2034
magenta="#bb9af7"
# shellcheck disable=SC2034
cyan="#7dcfff"

# set bemenu command options
basecolor="$blue"
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

if ! is-4k; then
  cmd+=(--bottom)
fi

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
