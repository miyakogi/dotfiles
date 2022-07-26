#!/usr/bin/env bash

##################
# list terminals
#
terminals=(
  alacritty
  kitty
  konsole
  urxvt
  xterm
)

if type st &>/dev/null; then
  terminals=(st ${terminals[@]})
fi

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  terminals=(foot ${terminals[@]})
fi

list_terminals() {
  for t in ${terminals[@]}; do
    if [[ "$XDG_SESSION_TYPE" == "wayland" ]]; then
      # wrap by spaces for bemenu
      echo " $t "
    else
      echo $t
    fi
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

# set bemenu command options
bemenu_cmd=(
  bemenu
  --prompt "$prompt"  # prompt
  --fn "Fira Code 15"  # font
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

# set dmenu command options
dmenu_cmd=(
  dmenu
  -p "$prompt"  # prompt
  -fn "Fira Code:Regular:pixelsize=20"  # font
  -nb "$black"  # normal background color
  -nf "$white"  # normal foreground color
  -sb "$cyan"   # selected background color
  -sf "$black"  # selected foreground color
)

if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
  cmd=("${bemenu_cmd[@]}")
else
  cmd=("${dmenu_cmd[@]}")
fi

#####################
# Execute
#

# choose terminal
_terminal=$( list_terminals | "${cmd[@]}" | tr -d '[:space:]' )

# modify some terminal command and launch
case $_terminal in
  st|xterm|urxvt)
    $_terminal -e fish &
    ;;
  foot)
    if [[ $(swaymsg -t get_outputs | jq '.[]  | select(.focused) | .name') == \"DP-1\" ]]; then
      foot --override=pad=12x12 --override=font="Sarasa Term J:weight=Light:size=22.5" &
    else
      foot &
    fi
    ;;
  *)
    $_terminal &
    ;;
esac

# send Muhenkan key if on Xorg
if [[ $XDG_SESSION_TYPE != "wayland" ]]; then
  sleep 0.3
  xdotool key Muhenkan
fi
