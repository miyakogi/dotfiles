#!/usr/bin/env python3

import logging
import os
from pathlib import Path
import shutil
import subprocess
import sys

if not sys.platform.startswith("linux"):
    raise Exception(f"This script only supports Linux\nUnsupported OS: {sys.platform}")

HOME = Path.home()
BASEDIR = Path(__file__).resolve().parent
CONFIG_HOME = Path(os.getenv("XDG_CONFIG_HOME") or HOME / ".config")
DATA_HOME = Path(os.getenv("XDG_DATA_HOME") or HOME / ".local" / "share")
PICTURES_DIR = Path(os.getenv("XDG_PICTURES_DIR") or HOME / "Pictures")
BINDIR = HOME / "bin"

# Used in distrobox environment
HOST_HOME = Path("/home") / os.getenv("USER", "")


class Formatter(logging.Formatter):
    _colors_int = {"red": 1, "green": 2, "yellow": 3, "blue": 4}

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.colors = {}
        try:
            import curses

            curses.setupterm()
            self.colors["normal"] = curses.tigetstr("sgr0").decode("utf-8")
            for color, val in self._colors_int.items():
                self.colors[color] = curses.tparm(curses.tigetstr("setaf"), val).decode(
                    "utf-8"
                )
        except Exception:
            self.colors["normal"] = ""
            for color in self._colors_int:
                self.colors[color] = ""

    def format(self, rec):
        fmt = "{color}[{level}:{name}]{normal} {msg}"
        config = {
            "level": rec.levelname[0],
            "name": rec.name,
            "msg": rec.msg,
            "normal": self.colors["normal"],
        }

        if rec.levelno >= logging.ERROR:
            config["color"] = self.colors["red"]
        elif rec.levelno >= logging.WARNING:
            config["color"] = self.colors["yellow"]
        elif rec.levelno >= logging.INFO:
            config["color"] = self.colors["green"]
        elif rec.levelno >= logging.DEBUG:
            config["color"] = self.colors["blue"]
        else:
            config["color"] = ""
        return fmt.format(**config)


# Make logger
logger = logging.getLogger("Install")
level = logging.INFO
logger.setLevel(level)
handler = logging.StreamHandler()
handler.setLevel(level)
handler.setFormatter(Formatter())
logger.addHandler(handler)
logger.propagate = False


def mkdir(p: Path) -> None:
    if not p.exists():
        p.mkdir(parents=True)
        logger.info(f"directory {p} created")
    elif p.is_dir():
        logger.debug(f"[skipped] directory {p} already exists")
    else:
        logger.warn(f"path {p} exists but not directory")


def install(src: Path, dest: Path) -> None:
    if not src.exists():
        logger.error(f"{src} not exists")
        return

    if not dest.parent.exists():
        mkdir(dest.parent)

    if dest.exists():
        if dest.is_symlink() and dest.resolve().samefile(src.resolve()):
            logger.debug(f"[skipped] symlink {dest} -> {src} exists")
            return
        else:
            logger.error(f"install target {dest} already exists")
            return

    dest.symlink_to(src, target_is_directory=src.is_dir())
    logger.info(f"symlink {dest} -> {src} created")


def git_clone(url: str, out: Path) -> None:
    if not shutil.which("git"):
        logger.error("could not find `git` command")
        return
    if out.exists():
        logger.debug(f"[skipped] {out} exists, skip git clone")
        return
    subprocess.run(["git", "clone", url, str(out)])
    logger.info(f"cloned {url} to {out}")


def is_orig_home() -> bool:
    """
    Check if $HOME is same as /home/$USER.
    If different, possibly running in distrobox container.
    """
    return HOST_HOME == HOME


def make_empty_directories() -> None:
    """
    These dirs don't contain config files but need to exist.
    """
    mkdir(HOME / ".tmux" / "plugins")
    if is_orig_home():
        mkdir(PICTURES_DIR / "screenshots" / "grim")
        mkdir(PICTURES_DIR / "screenshots" / "swappy")


def install_base() -> None:
    """
    Install config files for both of host and distrobox container.
    """

    logger.info("Install Base Config")

    #########################
    # Install for TTY Login #
    #########################

    # bash files
    BASHDIR = BASEDIR / "bash"
    install(BASHDIR / "bash_profile", HOME / ".bash_profile")
    install(BASHDIR / "bash_login", HOME / ".bash_login")
    install(BASHDIR / "bashrc", HOME / ".bashrc")


    # fish shell
    install(BASEDIR / "fish", CONFIG_HOME / "fish")

    # git
    install(BASEDIR / "git" / "gitignore", HOME / ".gitignore_global")
    install(BASEDIR / "git" / "gitconfig", HOME / ".gitconfig")

    # paru
    install(BASEDIR / "paru", CONFIG_HOME / "paru")

    # gitui - terminal ui for git
    install(BASEDIR / "gitui", CONFIG_HOME / "gitui")

    # rust/cargo
    install(BASEDIR / "cargo" / "config", HOME / ".cargo" / "config")

    # pip (pip's --no-binary option for some packages on linux)
    install(BASEDIR / "pip", CONFIG_HOME / "pip")

    # tmux
    install(BASEDIR / "tmux" / "tmux.conf", HOME / ".tmux.conf")

    # zellij
    install(BASEDIR / "zellij", CONFIG_HOME / "zellij")

    # zellij
    install(BASEDIR / "helix", CONFIG_HOME / "helix")

    # neovim
    NVIM_BASE = BASEDIR / "nvim"
    NVIM_HOME = CONFIG_HOME / "nvim"
    install(NVIM_BASE / "init.lua", NVIM_HOME / "init.lua")
    install(NVIM_BASE / "manrc", NVIM_HOME / "manrc")
    install(NVIM_BASE / "lua", NVIM_HOME / "lua")
    install(NVIM_BASE / "after", NVIM_HOME / "after")
    install(NVIM_BASE / "colors", NVIM_HOME / "colors")
    install(NVIM_BASE / "ftplugin", NVIM_HOME / "ftplugin")
    install(NVIM_BASE / "snippets", NVIM_HOME / "snippets")

    # direnv
    install(BASEDIR / "direnv", CONFIG_HOME / "direnv")

    # lf - terminal file manager
    install(BASEDIR / "lf", CONFIG_HOME / "lf")

    # lsd
    install(BASEDIR / "lsd", CONFIG_HOME / "lsd")

    # starship shell prompt
    install(BASEDIR / "starship.toml", CONFIG_HOME / "starship.toml")

    ###############################
    # Install plugins from github #
    ###############################
    # tmux
    git_clone(
        "https://github.com/tmux-plugins/tpm",
        HOME / ".tmux" / "plugins" / "tpm",
    )


def install_desktop() -> None:
    """
    Install config for tty-login by bash and desktop files.
    """
    logger.info("Install Desktop Config")

    ##############################
    # Install for Desktop System #
    ##############################

    ### Scripts for desktop system
    SCRIPTSDIR = BASEDIR / "scripts"
    install(SCRIPTSDIR / "is-4k.sh", BINDIR / "is-4k")
    install(SCRIPTSDIR / "launch-terminal.sh", BINDIR / "launch-terminal")
    install(SCRIPTSDIR / "launch-alacritty.sh", BINDIR / "launch-alacritty")
    install(SCRIPTSDIR / "launch-wezterm.sh", BINDIR / "launch-wezterm")
    install(SCRIPTSDIR / "launch-foot.sh", BINDIR / "launch-foot")
    install(SCRIPTSDIR / "launch-kitty.sh", BINDIR / "launch-kitty")
    install(SCRIPTSDIR / "launch-menu.sh", BINDIR / "launch-menu")
    install(SCRIPTSDIR / "leave.sh", BINDIR / "leave")
    install(SCRIPTSDIR / "sway-scratchterm.py", BINDIR / "sway-scratchterm")
    install(SCRIPTSDIR / "hypr-scratchterm.sh", BINDIR / "hypr-scratchterm")
    install(SCRIPTSDIR / "scratchterm-tmux.sh", BINDIR / "scratchterm-tmux")
    install(SCRIPTSDIR / "lock-screen.sh", BINDIR / "lock-screen")
    install(SCRIPTSDIR / "chromium-options.sh", BINDIR / "chromium-options")
    install(SCRIPTSDIR / "ff-volume-watch.sh", BINDIR / "ff-volume-watch")
    install(SCRIPTSDIR / "ff-volume-toggle.sh", BINDIR / "ff-volume-toggle")
    install(SCRIPTSDIR / "mic-mute-watch.sh", BINDIR / "mic-mute-watch")
    install(SCRIPTSDIR / "mic-mute-toggle.sh", BINDIR / "mic-mute-toggle")
    install(SCRIPTSDIR / "sway-idle-watch.sh", BINDIR / "sway-idle-watch")
    install(SCRIPTSDIR / "sway-idle-toggle.sh", BINDIR / "sway-idle-toggle")
    install(SCRIPTSDIR / "sway-addws.py", BINDIR / "sway-addws")
    install(SCRIPTSDIR / "hypr-addws.sh", BINDIR / "hypr-addws")
    install(SCRIPTSDIR / "waybar-mediaplayer.sh", BINDIR / "waybar-mediaplayer")
    install(SCRIPTSDIR / "waybar-mpris-command.py", BINDIR / "waybar-mpris-command")
    install(SCRIPTSDIR / "waybar-update.sh", BINDIR / "waybar-update")
    install(SCRIPTSDIR / "bw-launch.sh", BINDIR / "bw-launch")
    install(SCRIPTSDIR / "temperature.sh", BINDIR / "temperature")
    install(SCRIPTSDIR / "sscomp.sh", BINDIR / "sscomp")

    ### Desktop
    # sway
    install(BASEDIR / "sway" / "config", CONFIG_HOME / "sway" / "config")
    install(BASEDIR / "sway" / "config.d", CONFIG_HOME / "sway" / "config.d")

    # swaybar (i3status-rust)
    install(BASEDIR / "i3status-rust", CONFIG_HOME / "i3status-rust")

    # hyprland
    install(BASEDIR / "hypr" / "hyprland.conf", CONFIG_HOME / "hypr" / "hyprland.conf")
    install(BASEDIR / "hypr" / "catppuccin-macchiato.conf", CONFIG_HOME / "hypr" / "catppuccin-macchiato.conf")
    install(BASEDIR / "hypr" / "catppuccin-mocha.conf", CONFIG_HOME / "hypr" / "catppuccin-mocha.conf")
    install(BASEDIR / "hypr" / "hyprpaper.conf", CONFIG_HOME / "hypr" / "hyprpaper.conf")

    # swaylock
    install(BASEDIR / "swaylock" / "config", CONFIG_HOME / "swaylock" / "config")

    # waybar (waybar-hypr)
    install(BASEDIR / "waybar", CONFIG_HOME / "waybar")

    # alacritty terminal
    install(BASEDIR / "alacritty", CONFIG_HOME / "alacritty")

    # wezterm terminal emulator
    install(BASEDIR / "wezterm", CONFIG_HOME / "wezterm")

    # kitty terminal
    install(BASEDIR / "kitty", CONFIG_HOME / "kitty")

    # foot terminal emulator for wayland
    install(BASEDIR / "foot", CONFIG_HOME / "foot")

    # keyd key-remapping
    install(BASEDIR / "keyd" / "app.conf", CONFIG_HOME / "keyd" / "app.conf")

    # fuzzel application launcher
    install(BASEDIR / "fuzzel", CONFIG_HOME / "fuzzel")

    # fnott notification daemon
    install(BASEDIR / "dunst", CONFIG_HOME / "dunst")

    # fnott notification daemon
    install(BASEDIR / "fnott", CONFIG_HOME / "fnott")

    # swappy
    install(BASEDIR / "swappy", CONFIG_HOME / "swappy")

    ### Font
    install(
        BASEDIR / "fontconfig" / "conf.d" / "10-default-fonts.conf",
        CONFIG_HOME / "fontconfig" / "conf.d" / "10-default-fonts.conf",
    )
    install(
        BASEDIR / "fontconfig" / "conf.d" / "20-no-embedded.conf",
        CONFIG_HOME / "fontconfig" / "conf.d" / "20-no-embedded.conf",
    )
    install(
        BASEDIR / "fontconfig" / "conf.d" / "30-ibm-plex-mono.conf",
        CONFIG_HOME / "fontconfig" / "conf.d" / "30-ibm-plex-mono.conf",
    )
    install(
        BASEDIR / "fontconfig" / "conf.d" / "30-jetbrainsmono.conf",
        CONFIG_HOME / "fontconfig" / "conf.d" / "30-jetbrainsmono.conf",
    )
    install(
        BASEDIR / "fontconfig" / "conf.d" / "90-nerd-font-symbols-jp.conf",
        CONFIG_HOME / "fontconfig" / "conf.d" / "90-nerd-font-symbols-jp.conf",
    )

    ####################
    # Systemd Services #
    ####################
    SERVICE_DIR = BASEDIR / "services"
    TARGET_DIR = DATA_HOME / "systemd" / "user"
    mkdir(TARGET_DIR)

    def install_service(service: str) -> None:
        install(SERVICE_DIR / service, TARGET_DIR / service)

    # Install targets
    install_service("user-graphical-session.target")
    install_service("wlr-graphical-session.target")
    install_service("sway-graphical-session.target")
    install_service("hypr-graphical-session.target")

    # WM/DE independent
    install_service("fcitx5.service")
    install_service("corectrl.service")

    # wlroots services
    install_service("swayidle.service")
    install_service("fnott.service")

    # for Sway
    install_service("autotiling.service")


def install_other_home() -> None:
    """
    Create link of some directories between host's home and distrobox's home
    """
    logger.info("Link Distrobox Container and Host's HOME")

    # Some shareable xdg-directories
    HOST_CONFIG_HOME = HOST_HOME / ".config"
    install(HOST_CONFIG_HOME / "nvim" / "spell", CONFIG_HOME / "nvim" / "spell")
    install(HOST_CONFIG_HOME / "ccache", CONFIG_HOME / "ccache")
    install(HOST_CONFIG_HOME / "fontconfig", CONFIG_HOME / "fontconfig")

    CACHE_DIR = HOME / ".cache"
    HOST_CACHE_DIR = HOST_HOME / ".cache"
    install(HOST_CACHE_DIR / "ccache", CACHE_DIR / "ccache")
    install(HOST_CACHE_DIR / "paru", CACHE_DIR / "paru")
    install(HOST_CACHE_DIR / "sccache", CACHE_DIR / "sccache")

    # Config files for packages installed by arch-install.sh
    install(HOST_CONFIG_HOME / "Kvantum", CONFIG_HOME / "Kvantum")
    install(HOST_CONFIG_HOME / "bat", CONFIG_HOME / "bat")


def main() -> None:
    # Make empty directories
    make_empty_directories()

    ##################
    # Install Starts #
    ##################
    install_base()
    if os.getenv("XDG_VTNR"):
        if is_orig_home():
            install_desktop()
        else:
            install_other_home()
    else:
        logger.info("SSH connection")

    # Complete Installation
    logger.info("Install Completed")


if __name__ == "__main__":
    main()
