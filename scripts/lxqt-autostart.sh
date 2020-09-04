#!/bin/sh

# lxqt monitor autostart
lxqt-config-monitor -l &

# disable screen saver
xset s off &

# turn off monitor when leave
xset dpms 0 0 1200 &

# enable screen lock
pgrep -x xautolock > /dev/null || xautolock -time 5 -locker "$HOME/.config/i3/lock.sh" &

# numlock on
numlockx on &

# unlock kwallet
/usr/lib/pam_kwallet_init &

# launch polybar
$HOME/.config/polybar/launch.sh &

# clipboard manager (klipper)
pgrep -x klipper > /dev/null || klipper &

# dunst notification manager
pgrep -x dunst > /dev/null || dunst &

# iBus imput method
pgrep -x ibus-daemon > /dev/null || ibus-daemon -drx &

# easystroke (mouse gesture)
pgrep -x easystroke > /dev/null || easystroke &

# yakuake (dropdown terminal)
pgrep -x yakuake > /dev/null || yakuake &