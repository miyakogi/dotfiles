#!/usr/bin/env bash

case "$1" in
  all)
    sensors_json=$(sensors -j)
    #temp=$(sensors -u | grep -P 'temp\d+_input' | cut -d' ' -f 4 | sort | tail -n 1 | sed -E 's/\..*$//g')
    ctemp=$(echo "$sensors_json" | jq '.["coretemp-isa-0000"] | .["Package id 0"] | .["temp1_input"] | floor')
    #gtemp=$(echo "$sensors_json" | jq '.["amdgpu-pci-0300"] | [ .edge.temp1_input, .junction.temp2_input, .mem.temp3_input ] | max | floor')
    gtemp=$(($(cat /sys/class/drm/card*/device/hwmon/hwmon*/temp1_input) / 1000))
    ;;
  cpu)
    temp=$(sensors -j | jq '.["coretemp-isa-0000"] | .["Package id 0"] | .["temp1_input"] | floor')
    ;;
  gpu)
    temp=$(sensors -j | jq '.["amdgpu-pci-0300"] | [ .edge.temp1_input, .junction.temp2_input, .mem.temp3_input ] | max | floor')
    ;;
  *)
    temp=0
    ;;
esac

if [ "$1" = all ]; then
  if [ "$ctemp" -lt 65 ] && [ "$gtemp" -lt 65 ]; then
    class="Idle"
    icon=""  # low
  elif [ "$ctemp" -lt 80 ] && [ "$gtemp" -lt 80 ]; then
    class="Warning"
    icon=""  # default
  else
    class="Critical"
    icon=""  # high
  fi
  echo -n "{ \"text\": \"${icon} CPU ${ctemp}°C | GPU ${gtemp}°C\", \"class\": \"$class\" }"
else
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
  echo -n "{ \"text\": \"${icon}  ${temp}°C\", \"$2\": \"$class\" }"
fi
