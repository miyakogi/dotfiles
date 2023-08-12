#!/bin/env bash

if [ "$(is-4k)" = true ]; then
  class=scratchterm-4k
else
  class=scratchterm-fhd
fi

get_term_address() {
  hyprctl clients -j | jq '.[] | select(.class == "'"$class"'") | .address' || true
}

is_exist() {
  test -n "$(get_term_address)"
}

start_term() {
  local cmd
  cmd=(
    launch-foot
    --app-id="$class"
    --override="colors.alpha=0.85"
    --override="pad=2x2"
  )

  declare -a zcmd
  if type zellij &>/dev/null; then
    zcmd=(zellij)
    if zellij ls | grep -E "^$class\$"; then
      # use existing session
      zcmd+=(a "$class")
    else
      # create new session
      zcmd+=(-s "$class")
    fi
  fi

  "${cmd[@]}" "${zcmd[@]}" &
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

hyprctl dispatch togglespecialworkspace "$class"
