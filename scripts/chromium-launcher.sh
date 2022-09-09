#!/usr/bin/env bash

################
# Description:
#   Launch a chromium-based browser with GPU enabled options, and support firejail and native-wayland optionally
#
# Usage:
#   chromium-launcher.sh [--firejail] TARGET-BROWSER [--wayland] [--additional-option-1] [--additional-option-2] ...
#
###############

# setup empty cmd array
cmd=()

# check firejail
if [[ "${1}" == "--firejail" ]]; then
  if type firejail &>/dev/null; then
    # Run browser inside firejail environment
    cmd+=(firejail)
    shift
  else
    echo "firejail is not installed"
    exit 1
  fi
fi

# check target browser
target="${1}"
if ! [[ -f "${target}" ]] && ! type "${target}" &>/dev/null; then
  echo "couldn't find target browser: ${target}"
  exit 1
fi

# add target browser command
cmd+=("${target}")
shift

# check wayland option
if [[ "${1}" == "--wayland" ]]; then
  mapfile -t -O "${#cmd[*]}" cmd < <(chromium-options wayland | sed -r 's/\s/\n/g')
  shift
else
  mapfile -t -O "${#cmd[*]}" cmd < <(chromium-options | sed -r 's/\s/\n/g')
fi

# execute command
"${cmd[@]}" "${@}"
