#!/usr/bin/bash

case "$1" in
  all)
    temp=$(sensors -u | grep -P 'temp\d+_input' | cut -d' ' -f 4 | sort | tail -n 1 | sed -E 's/\..*$//g')
    ;;
  cpu)
    temp=$(sensors -j | jq '.["coretemp-isa-0000"] | .["Package id 0"] | .["temp1_input"]')
    ;;
  gpu)
    temp=$(sensors -j | jq '.["amdgpu-pci-0300"] | [ .edge.temp1_input, .junction.temp2_input, .mem.temp3_input ] | max')
    ;;
  *)
    temp=0
    ;;
esac
shift


if [ "$temp" -lt 65 ]; then
  class="Idle"
  icon=""  # low
elif [ "$temp" -lt 80 ]; then
  class="Warning"
  icon=""  # default
else
  class="Critical"
  icon=""  # high
fi

echo -n "{ \"text\": \"${icon} ${temp}°C\", \"$1\": \"$class\" }"
