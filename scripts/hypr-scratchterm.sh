#!/bin/env bash

get_term_address() {
  hyprctl clients -j | jq '.[] | select(.class == "scratchterm") | .address' || true
}

is_exist() {
  test -n "$(get_term_address)"
}

start_term() {
  local cmd
  cmd=(
    foot
    --app-id="scratchterm"
    --override="colors.alpha=0.85"
    --override="pad=2x2"
  )

  if [ "$(is-4k)" = false ]; then
    cmd+=(
      --override=font="IBM Plex Mono:size=12.0"
    )
  fi
  "${cmd[@]}" &
}

if ! is_exist; then
  start_term
  for _ in seq 100; do
    sleep 0.01
    if is_exist; then
      break
    fi
  done
  if ! is_exist; then
    exit 1
  fi
fi

hyprctl dispatch togglespecialworkspace scratchterm
