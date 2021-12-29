#!/usr/bin/sh

term=alacritty
term_class=scratchterm

# get window id of currently runnning dropdown terminal
wid=$(xdotool search --classname $term_class)

if [[ -z $wid ]]; then
  # if dropdown terminal is not running, start it
  $term --class $term_class \
    --option env.TERM=xterm-256color \
    --option background_opacity=0.7 \
    --option window.padding.x=2 \
    --option window.padding.y=2 \
    --command scratchterm-tmux &

  # get new window id of dropdown terminal (wait until window appears)
  wid=`xdotool search --sync --classname $term_class`

  # show new dropdown terminal window
  bspc node $wid --flag hidden -f
else
  # dropdown terminal is running
  if [[ `xdotool getactivewindow` -eq $wid ]]; then
    # currently focused on dropdown terminal, so hide it
    bspc node $wid --flag hidden -f
  else
    if [[ ! `xdotool search --onlyvisible --classname $term_class` ]]; then
      # dropdown terminal is hidden, so toggle it and show
      bspc node $wid --flag hidden -f
    fi

    # focus to the dropdown terminal
    xdotool search --classname $term_class windowactivate
  fi
fi
