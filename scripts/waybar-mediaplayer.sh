#!/usr/bin/env bash

MPD_HOST="arch-n100"

tmpfile="/tmp/playerctl-current-player"
if [ ! -e "$tmpfile" ]; then
  touch "$tmpfile"
fi

get_players() {
  playerctl -l 2>/dev/null
}

get_current_player() {
  current=$(cat "$tmpfile")
  if [ -z "$current" ]; then
    current="$(playerctl -l 2>/dev/null | head -n 1)"
    echo -n "$current" > "$tmpfile"
  fi
  echo -n "$current"
}

next_player() {
  current=$(get_current_player)
  found=0
  for p in $(get_players); do
    if [ "$found" -ne 0 ]; then
      echo -n "$p" > "$tmpfile"
      return 0
    fi
    if [ "$p" = "$current" ]; then
      found=1
    fi
  done
  echo -n "$(get_players)" | head -n 1 | tr -d '[:space:]' > "$tmpfile"
}

previous_player() {
  current=$(get_current_player)
  found=0
  for p in $(get_players | tac); do
    if [ "$found" -ne 0 ]; then
      echo -n "$p" > "$tmpfile"
      return 0
    fi
    if [ "$p" = "$current" ]; then
      found=1
    fi
  done
   echo -n "$(get_players)" | tail -n 1 | tr -d '[:space:]' > "$tmpfile"
}

get_data() {
  player=$(get_current_player)
  song="$(playerctl -p "$player" metadata --format '{{markup_escape(title)}} - {{markup_escape(artist)}}' 2>/dev/null)"
  if [ "$song" = ' - ' ]; then
    song="$(playerctl -p "$player" metadata --format '{{markup_escape(xesam:url)}}' 2>/dev/null)"
    if [[ "$song" == "file://"* ]]; then
      song="$(basename "$song" | cut -d. -f1)"
    fi
  fi

  if [[ "$song" =~ https?://.* ]]; then
    echo -n "$song"
    return
  fi

  duration="$(playerctl -p "$player" metadata --format '{{duration(position)}}/{{duration(mpris:length)}}' 2>/dev/null)"
  # cannot get song length from qobuz via mpDris2, then fallback to mpc
  if [[ "$duration" = *"/" ]]; then
    duration="$(mpc --host $MPD_HOST status '%currenttime%/%totaltime%')"
  fi
  echo -n "$song | $duration"
}

get_icon() {
  player="$1"
  case "$player" in
    spotify_player)
      icon="󰓇"
      ;;
    spotify)
      icon="󰓇"
      ;;
    mpd)
      icon="󰫔"
      ;;
    firefox*)
      icon=""
      ;;
    chromium*)
      icon="󰊯"
      ;;
    *)
      icon="󰫔"
      ;;
  esac
  echo -n "$icon"
}

get_status() {
  playerctl -p "$1" status 2>/dev/null
}

main() {
  player=$(get_current_player)
  echo -n "{\"text\": \"$(get_icon "$player") $(get_data "$player")\", \"class\": \"$(get_status "$player")\"}"
}

case "$1" in
  next-player)
    next_player;;
  previous-player)
    previous_player;;
  next)
    playerctl -p "$(get_current_player)" next;;
  previous)
    playerctl -p "$(get_current_player)" previous;;
  toggle)
    playerctl -p "$(get_current_player)" play-pause;;
  *)
    main;;
esac
