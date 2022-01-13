#!/usr/bin/env bash

# Check executables
check_executable() {
  if ! type $1 &>/dev/null; then
    echo "Need $1 command"
    exit 1
  fi
}

check_executable "wmctrl"
check_executable "qdbus"
check_executable "kwriteconfig5"
check_executable "kreadconfig5"

# Check window manager is kwin
if wmctrl -m | grep "Name:" | grep -q -v -i "kwin"; then
  echo "Current window manager is not Kwin"
  exit 1
fi

# Set variables
case $1 in
  enable)
    types='305'
    enabled='true'
    ;;
  disable)
    types='4'
    enabled='false'
    ;;
  *)
    echo "Valid commands are [enable|disable]"
    exit
    ;;
esac

# Disable/Enable window border and title bar
rulesrc="${XDG_CONFIG_HOME:-$HOME/.config}/kwinrulesrc"
if grep -q "noborder=true" $rulesrc; then
  count=$(kreadconfig5 --file $rulesrc --group General --key count)
  for i in $(seq $count); do
    if [[ $(kreadconfig5 --file $rulesrc --group $i --key Description) == *Titlebar* ]] && \
      [[ $(kreadconfig5 --file $rulesrc --group $i --key noborder) == "true" ]]; then
      kwriteconfig5 --file $rulesrc --group $i --key 'types' $types
      break
    fi
  done
fi

# Enable/Disable bismuth
kwinrc="${XDG_CONFIG_HOME:-$HOME/.config}/kwinrc"
if grep -q "bismuthEnabled" $kwinrc && [[ "$enabled" == "false" ]]; then
  kwriteconfig5 --file $kwinrc --group Plugins --delete --key 'bismuthEnabled'
else
  kwriteconfig5 --file $kwinrc --group Plugins --type bool --key 'bismuthEnabled' $enabled
fi

# Reconfigure kwin
qdbus org.kde.KWin /KWin org.kde.KWin.reconfigure
