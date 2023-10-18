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
    zellij
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
white="#e0def4"
# shellcheck disable=SC2034
black="#191724"
# shellcheck disable=SC2034
red="#eb6f92"
# shellcheck disable=SC2034
green="#31748f"
# shellcheck disable=SC2034
yellow="#f6c177"
# shellcheck disable=SC2034
blue="#9ccfd8"
# shellcheck disable=SC2034
magenta="#c4a7e7"
# shellcheck disable=SC2034
cyan="#ebbcba"

# set bemenu command options
basecolor="$magenta"
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
  zellij)
    launch-foot bash -c "sleep 0 && zellij" &
    ;;
  *)
    $_terminal &
    ;;
esac
