#!/usr/bin/env bash

: << COMMENTOUT
Run default terminal.

Available options:
  - alacritty
  - foot
  - havoc
  - kitty
  - rio
  - wezterm
COMMENTOUT

case "$XDG_CURRENT_DESKTOP" in
  Hyprland)
    # Hyprland default terminal
    _term=wezterm
    ;;
  sway)
    # Sway default terminal
    _term=foot
    ;;
  *)
    _term=alacritty
    ;;
esac

cmd=("$_term")

case "$_term" in
  wezterm)
    cmd+=(start --always-new-process)
    ;;
  *)
    ;;
esac

if [ "$1" = "--class" ]; then
  case "$_term" in
    alacritty)
      cmd+=(--class "$2")
      ;;
    foot)
      cmd+=(--app-id "$2")
      ;;
    havoc)
      cmd+=(-i "$2")
      ;;
    kitty)
      cmd+=(--app-id "$2")
      ;;
    rio)
      cmd+=(--title "$2")
      ;;
    wezterm)
      cmd+=(--class "$2")
      ;;
    *)
      cmd+=(--class "$2")
      ;;
  esac
  shift 2
fi

if [ "$1" = "-e" ]; then
  case "$_term" in
    alacritty)
      # must
      ;;
    foot)
      # optional
      shift
      ;;
    havoc)
      # should not exist
      shift
      ;;
    kitty)
      # optional
      shift
      ;;
    rio)
      # must
      ;;
    wezterm)
      # optional
      shift
      ;;
    *)
      ;;
  esac
fi

"${cmd[@]}" "$@"
