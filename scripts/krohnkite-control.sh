#!/bin/sh

# Check executables
function check_executable() {
  if ! which $1 >/dev/null 2>&1; then
    echo "Need $1 command"
    exit 1
  fi
}

check_executable "wmctrl"
check_executable "qdbus"
check_executable "kwriteconfig5"
check_executable "kreadconfig5"

# Check window manager is kwin
if wmctrl -m | grep "Name:" | grep -v -i "kwin" > /dev/null; then
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
rulesrc="$HOME/.config/kwinrulesrc"
if grep "noborder=true" $rulesrc > /dev/null; then
  count=$(kreadconfig5 --file $rulesrc --group General --key count)
  for i in `seq $count`; do
    # TODO: maybe better to use desctipton field
    if [[ $(kreadconfig5 --file $rulesrc --group $i --key noborder) = "true" ]]; then
      kwriteconfig5 --file $rulesrc --group $i --key 'types' $types
      break
    fi
  done
fi

# Enable/Disable krohnkite
kwinrc="$HOME/.config/kwinrc"
if grep "krohnkiteEnabled" $kwinrc > /dev/null; then
  kwriteconfig5 --file $kwinrc --group Plugins --type bool --key 'krohnkiteEnabled' $enabled
fi

# Reconfigure kwin
qdbus org.kde.KWin /KWin org.kde.KWin.reconfigure
