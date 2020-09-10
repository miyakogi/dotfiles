# Dotfiles

My dotfiles for Arch Linux.

Display manager is not supported.
Use TTY login at tty-1 (default) and select DE/WM.

## Supported Applications

These applications should be all installed.

### Terminal

- zsh
- git
- alacritty
- kitty
- vim/neovim
- tmux
- ctags
- (rust) cargo

### Desktop

- i3-gaps
- bspwm
- sxhkd
- picom (picom-git)
- conky (conky-cairo)
- dunst
- polybar
- rofi
- plasma (X11)
- lxqt (kwin + krohnkite)

## Required Applications (not listed above)

### Fonts

- Source Han Sans JP
- Fira Code Nerd Font Mono
- Noto Emoji Nerd Font Mono
- unifont
- Hack
- Raleway

### Terminal

- (python) virtualenv/virtualenv-wrapper
- (python) cookiecutter

#### Optional

- skim/percol
- exa/lsd (`ls` alternatives)
- bat (`cat` alternative)

### Desktop

- xorg-xinit
- xlogin
- xdotool
- wmctrl (check current WM)
- kwallet-pam (password management)
- xorg-xset (display power management)
- numlockx
- autotiling (for i3 auto-tiling)
- i3locks-color (screen lock)
- dmenu
- redshift
- ibus
- ibus-mozc
- easystroke
- feh
- klipper
- perl-anyevent-i3 (save layout)
- perl-json-xs (save layout)
- python-i3ipc (scratchpad control and add workspace function)
- pulsemixer (polybar's volume check/fix)
- pavucontrol-qt
- qt5ct (qt5 app theming)
- yakuake
- kwin-scripts-krohnkite-git

## Install

After installing all requirements, run:

```sh
# Install config files
./install.sh

# Change defualt shell to zsh
# check if output of `which zsh` is included in `chsh -l` and then run:
chsh -s $(which zsh)
```

## Setup

### Enable TTY Login

Disable display managers (e.g. SDDM or GDM) if enabled.

### Kwallet auto unlock

In `/etc/pam.d/login`, add:

```
auth optional pam_kwallet5.so
session optional pam_kwallet5.so auto_start
```

### Set Lock Screen Image

Use lock images for each WM as below:

- i3: `~/.config/i3/lock.{jpg,png}`
- bspwm: `~/.config/bspwm/lock.{jpg,png}`
- lxqt: `~/.config/lxqt/lock.{jpg,png}`

If no image file is found, simply blur the desktop when lock screen.

### Plasma/LXQt Manual Setup

In LXQt session settings, set window manager to `kwin_x11`.

#### Krohnkite

Add kwin window rule to disable title bars on LXQt session (krohnkite is enabled).

`KDE System Settings` -> `Window Management` -> `Window Rules` -> press `Add New`, then set:

- Description: MUST include `Titlebar`
- Window class (application): select `Regular Expression`, set `.*`
- Appearance & Fixes: `No titlebar and frame`, select `Force`, select `Yes`

When re-login to the LXQt session, titlebars will be removed.
In plasma session, this setting will be automatically disabled.
