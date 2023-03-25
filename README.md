# Dotfiles

My dotfiles for Arch Linux.

Display manager is not supported.
Use TTY login at tty-1 (default) and select Shell/DE/WM.

## Install

At first, confirm that `base` and `base-devel` packages are installed:

```
sudo pacman -S base base-devel
```

Then, on Arch Linux, install packages by run:

```
./arch-install.sh
```

This installs all required packages.
**Other Distributions (including Arch-Derivatives) are not supported**.
If you still want to try, check packages in `arch-install.sh` script and install them manually.

Then make config files for supported applications, run:

```sh
./install.py
```

## Setup

### Enable TTY Login

Disable display managers (e.g. SDDM or GDM) if enabled.

### Enable Systemd User Services

Enable systemd services for graphical session.

```sh
systemctl --user enable --now autotiling.service dunst-notification.service fcitx5.service swayidle.service
```

Then logout/login or reboot.

### Set Wallpaper and Lock Screen Image

Use wallpaper for each WM as below:

- sway: `$XDG_CONFIG_HOME/sway/bg{,_4k}.png`

Use lock images for each WM as below:

- sway: `$XDG_CONFIG_HOME/sway/lock{,_4k}.{png,jpg}`

Monitor settings are hard-coded for my environment (DP-1 for 4K 144Hz main monitor and DP-2 for FHD 144Hz sub monitor).
