#!/usr/bin/env bash

if is-4k; then
  class=scratchterm-dp1
else
  class=scratchterm-dp2
fi

get_term_address() {
  if [ "$TERMINAL" = "rio" ]; then
    hyprctl clients -j | jq '.[] | select(.title | test("'"$class"'")) | .address' ||true
  else
    hyprctl clients -j | jq '.[] | select(.class | test("'"$class"'")) | .address' ||true
  fi
}

is_exist() {
  test -n "$(get_term_address)"
}

start_term() {
  local cmd
  cmd=(
    terminal
    --class "$class"
    -e bash -c
  )

  declare -a zcmd
  if type zellij &>/dev/null; then
    zcmd=(zellij)
    if zellij ls | grep -E "^$class\$"; then
      # use existing session
      zcmd+=(attach "$class")
    else
      # create new session
      zcmd+=(--session "$class")
    fi
  else
    zcmd=(fish)
  fi

  # exec "${cmd[@]}" bash -c "sleep 0.01 && zellij attach $class || zellij --session $class || fish "
  exec "${cmd[@]}" "sleep 0.01 && ${zcmd[*]}"
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
