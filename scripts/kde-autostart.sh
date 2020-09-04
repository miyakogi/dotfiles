#!/bin/sh

if [[ -n $KDEWM ]]; then
  exit
fi

# disable krohnkite
krohnkite-control disable &

# ibus input method
pgrep -x ibus-daemon > /dev/null || ibus-daemon -drx --panel /usr/lib/ibus/ibus-ui-gtk3 &

# easystroke (mouse gesture)
pgrep -x easystroke > /dev/null || easystroke &

# ksuperkey
pgrep -x ksuperkey > /dev/null || ksuperkey &

# yakuake
pgrep -x yakuake > /dev/null || yakuake &

# xbindkeys
pgrep -x xbindkeys > /dev/null || xbindkeys &
