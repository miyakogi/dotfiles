# Dotfiles

My dotfiles.

## Supported Applications

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
- picom (picom-ibhagwan-git)
- conky (conky-cairo)
- dunst
- polybar
- rofi

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
- python-i3-py (polybar's add workspace function)
- python-i3ipc (scratchpad control)
- pulsemixer (polybar's volume check/fix)
- pavucontrol-qt
- kitty

## Install

```sh
# Install config files
./install.sh

# Change defualt shell to zsh
chsh /bin/zsh
```
