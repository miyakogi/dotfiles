#!/usr/bin/bash

### BubbleWrap command wrapper script for GUI applications in distrobox

### Usage
# ```
# distrobox enter <box-name> --additional-flags "--env USER=$USER" -- bw-launch [--option ...] command [command-options ...]
# ```
#
# options:
#   --wayland: enable wayland socket connection
#   --x11|--X11: enable x11 socket connection
#   --pipewire: enable pipewire connection
#   --pulse: enable pulseaudio server connection
#   --dbus: enable dbus socket connection
#   --lib-bind <lib_path>: application specific --ro-bind for library
#   --home <local_home>: application specific home dir relative to $HOME/.home/
#   --home-bind-local <local-path>: --bind local-home directory relative to $local_home
#   --home-bind-host <relative-path>: --bind host-home to local-home directory relative to host-home/local-home
#   --env <VAR> <VAL>: --setenv <VAR> <VAL>
#   --chromium: enable chromium gui options
#   command: path to main command to be executed
#   [command-options ...]: additional options for `command` directly placed after `command`, but may conflict with --chromium option

### Example:
# Firefox (Wayland):
# ```
# distrobox enter firefox-box --additional-flags "--env USER=$USER" -- \
#   bw-launch \
#   --wayland \
#   --pipewire \
#   --pulse \
#   --dbus \
#   --lib-bind /usr/bin/firefox \
#   --home firefox \
#   --home-bind-local .mozilla \
#   --home-bind-host .cache/mozilla \
#   --env GTK_THEME Adwaita:dark \
#   --env MOZ_ENABLE_WAYLAND 1 \
#   /usr/bin/firefox \
#   --no-remote
# ```
#
# Chroimium (X11):
# ```
# distrobox enter chromium-box --additional-flags "--env USER=$USER" -- \
#   bw-launch \
#   --x11 \
#   --pulse \
#   --dbus \
#   --lib-bind /usr/bin/chromium \
#   --home chromium \
#   --home-bind-local .cache/chromium \
#   --home-bind-local .config/chromium \
#   --chromium
#   /usr/bin/chromium
# ```


# Setup base command and flags
cmd=(
  bwrap
  --symlink usr/lib /lib
  --symlink usr/lib64 /lib64
  --symlink usr/bin /bin
  --symlink usr/bin /sbin
  --ro-bind /usr/lib /usr/lib
  --ro-bind /usr/lib64 /usr/lib64
  --ro-bind /usr/bin /usr/bin
  --ro-bind /usr/share/applications /usr/share/applications
  --ro-bind /usr/share/gtk-3.0 /usr/share/gtk-3.0
  --ro-bind /run/host/usr/share/fontconfig /usr/share/fontconfig  # use fonts config in host
  --ro-bind /usr/share/icu /usr/share/icu
  --ro-bind /usr/share/drirc.d /usr/share/drirc.d
  --ro-bind /run/host/usr/share/fonts /usr/share/fonts  # use fonts in host
  --ro-bind /usr/share/glib-2.0 /usr/share/glib-2.0
  --ro-bind /usr/share/glvnd /usr/share/glvnd
  --ro-bind /usr/share/icons /usr/share/icons
  --ro-bind /usr/share/libdrm /usr/share/libdrm
  --ro-bind /usr/share/mime /usr/share/mime
  --ro-bind /usr/share/X11/xkb /usr/share/X11/xkb
  --ro-bind /usr/share/icons /usr/share/icons
  --ro-bind /usr/share/mime /usr/share/mime
  --ro-bind /run/host/etc/fonts /etc/fonts  # use fonts config in host
  --ro-bind /etc/resolv.conf /etc/resolv.conf
  --ro-bind /usr/share/ca-certificates /usr/share/ca-certificates
  --ro-bind /etc/ssl /etc/ssl
  --ro-bind /etc/ca-certificates /etc/ca-certificates
  --ro-bind /etc/localtime /etc/localtime
  --dir "/run/user/$(id -u)"
  --dev /dev
  --dev-bind /dev/dri /dev/dri
  --ro-bind /sys/dev/char /sys/dev/char
  --ro-bind /sys/devices/pci0000:00 /sys/devices/pci0000:00
  --proc /proc
  --setenv PATH /usr/bin
  --hostname RESTRICTED
  --unshare-all
  --share-net
  --die-with-parent
  --new-session
  --tmpfs /tmp
)

declare local_home
declare -a options

while [[ "$1" = "--"* ]]; do
  case "$1" in
    --wayland)
      cmd+=(
        --ro-bind "/run/user/$(id -u)/wayland-1" "/run/user/$(id -u)/wayland-1"
      )
      shift
      ;;
    --x11|--X11)
      cmd+=(
        --ro-bind /tmp/.X11-unix/X0 /tmp/.X11-unix/X0
        --setenv XDG_RUNTIME_DIR /run/user/"$(id -u)"
        --setenv DISPLAY "$DISPLAY"
      )
      shift
      ;;
    --pipewire)
      cmd+=(
        --ro-bind "/run/user/$(id -u)/pipewire-0" "/run/user/$(id -u)/pipewire-0"
      )
      shift
      ;;
    --pulse)
      cmd+=(
        --ro-bind /run/user/"$(id -u)"/pulse /run/user/"$(id -u)"/pulse
      )
      shift
      ;;
    --dbus)
      cmd+=(
        --ro-bind "/run/user/$(id -u)/bus" "/run/user/$(id -u)/bus"
        --setenv DBUS_SESSION_BUS_ADDRESS "unix:path=/run/user/$(id -u)/bus"
      )
      shift
      ;;
    --home)
      # Set program specific home
      local_home="/home/$USER/.home/$2"
      cmd+=(
        # prepare xdg-dir
        --dir "$local_home/.cache"
        --dir "$local_home/.config"
        --dir "$local_home/.local/share"

        # use host config
        --ro-bind "/home/$USER/.config/fontconfig" "$local_home/.config/fontconfig"
        --ro-bind "/home/$USER/.config/gtk-3.0" "$local_home/.config/gtk-3.0"
        --ro-bind "/home/$USER/.config/gtk-4.0" "$local_home/.config/gtk-4.0"
        --ro-bind "/home/$USER/.local/share/icons" "$local_home/.local/share/icons"

        # enable rw-access to `Downloads` dir and ro-access to `Pictures`
        --bind "/home/$USER/Downloads" "$local_home/Downloads"
        --ro-bind "/home/$USER/Pictures" "$local_home/Pictures"

        # set local_home as HOME
        --setenv HOME "$local_home"
      )
      shift
      shift
      ;;
    --lib-bind)
      cmd+=(
        --ro-bind "$2" "$2"
      )
      shift
      shift
      ;;
    --home-bind-local)
      # Bind to local home dir
      cmd+=(
        --bind "$local_home/$2" "$local_home/$2"
      )
      shift
      shift
      ;;
    --home-bind-host)
      # Bind to host home dir
      cmd+=(
        --bind "/home/$USER/$2" "$local_home/$2"
      )
      shift
      shift
      ;;
    --bind)
      # Bind directory
      cmd+=(
        --bind "$2" "$2"
      )
      shift
      shift
      ;;
    --env)
      # Set env var
      cmd+=(
        --setenv "$2" "$3"
      )
      shift
      shift
      shift
      ;;
    --chromium)
      # Add chromium options
      if [[ "${*}" = *--wayland* ]] || [[ "${cmd[*]}" = *wayland-1* ]]; then
        mapfile -t options < <(chromium-options wayland)
      else
        mapfile -t options < <(chromium-options)
      fi
      shift
      ;;
    *)
      echo -e "\e[1;31m============ [ERROR] ============\e[m"
      echo -e "\e[1;33mUnknown Option: ${1}\e[m"
      exit 1
      ;;
  esac
done

"${cmd[@]}" "${@}" "${options[@]}"
