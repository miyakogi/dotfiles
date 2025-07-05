#!/usr/bin/env python3

import logging
import os
from pathlib import Path
import shutil
import subprocess
import sys

if not sys.platform.startswith("linux"):
    emsg = f"This script only supports Linux\nUnsupported OS: {sys.platform}"
    raise Exception(emsg)

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

    def format(self, record):
        fmt = "{color}[{level}:{name}]{normal} {msg}"
        config = {
            "level": record.levelname[0],
            "name": record.name,
            "msg": record.msg,
            "normal": self.colors["normal"],
        }

        if record.levelno >= logging.ERROR:
            config["color"] = self.colors["red"]
        elif record.levelno >= logging.WARNING:
            config["color"] = self.colors["yellow"]
        elif record.levelno >= logging.INFO:
            config["color"] = self.colors["green"]
        elif record.levelno >= logging.DEBUG:
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
        logger.warning(f"path {p} exists but not directory")


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
    install(BASEDIR / "cargo" / "config.toml", HOME / ".cargo" / "config.toml")

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
    install(NVIM_BASE / "ftplugin", NVIM_HOME / "ftplugin")
    install(NVIM_BASE / "snippets", NVIM_HOME / "snippets")

    # direnv
    install(BASEDIR / "direnv", CONFIG_HOME / "direnv")

    # yazi - terminal file manager
    install(BASEDIR / "yazi", CONFIG_HOME / "yazi")

    # bat
    install(BASEDIR / "bat", CONFIG_HOME / "bat")

    # starship shell prompt
    install(BASEDIR / "starship" / "starship.toml",
            CONFIG_HOME / "starship.toml")

    # macchina
    install(BASEDIR / "macchina", CONFIG_HOME / "macchina")


def install_desktop() -> None:
    """
    Install config for tty-login by bash and desktop files.
    """
    logger.info("Install Desktop Config")

    ##############################
    # Install for Desktop System #
    ##############################

    # Scripts for desktop system
    SCRIPTSDIR = BASEDIR / "scripts"
    install(SCRIPTSDIR / "is-4k.sh", BINDIR / "is-4k")
    install(SCRIPTSDIR / "launch-menu.sh", BINDIR / "launch-menu")
    install(SCRIPTSDIR / "leave.sh", BINDIR / "leave")
    install(SCRIPTSDIR / "sway-scratchterm.py", BINDIR / "sway-scratchterm")
    install(SCRIPTSDIR / "hypr-scratchterm.sh", BINDIR / "hypr-scratchterm")
    install(SCRIPTSDIR / "lock-screen.sh", BINDIR / "lock-screen")
    install(SCRIPTSDIR / "chromium-options.sh", BINDIR / "chromium-options")
    install(SCRIPTSDIR / "ff-volume-watch.sh", BINDIR / "ff-volume-watch")
    install(SCRIPTSDIR / "ff-volume-toggle.sh", BINDIR / "ff-volume-toggle")
    install(SCRIPTSDIR / "mic-mute-watch.sh", BINDIR / "mic-mute-watch")
    install(SCRIPTSDIR / "mic-mute-toggle.sh", BINDIR / "mic-mute-toggle")
    install(SCRIPTSDIR / "idle-watch.sh", BINDIR / "idle-watch")
    install(SCRIPTSDIR / "idle-toggle.sh", BINDIR / "idle-toggle")
    install(SCRIPTSDIR / "sway-addws.py", BINDIR / "sway-addws")
    install(SCRIPTSDIR / "hypr-addws.sh", BINDIR / "hypr-addws")
    install(SCRIPTSDIR / "waybar-mediaplayer.sh",
            BINDIR / "waybar-mediaplayer")
    install(SCRIPTSDIR / "waybar-update.sh", BINDIR / "waybar-update")
    install(SCRIPTSDIR / "bw-launch.sh", BINDIR / "bw-launch")
    install(SCRIPTSDIR / "temperature.sh", BINDIR / "temperature")
    install(SCRIPTSDIR / "terminal.sh", BINDIR / "terminal")
    install(SCRIPTSDIR / "launch-logseq.sh", BINDIR / "launch-logseq")
    install(SCRIPTSDIR / "screenshot.sh", BINDIR / "screenshot")

    # Desktop
    # sway
    install(BASEDIR / "sway" / "config", CONFIG_HOME / "sway" / "config")
    install(BASEDIR / "sway" / "config.d", CONFIG_HOME / "sway" / "config.d")

    # swaybar (i3status-rust)
    install(BASEDIR / "i3status-rust", CONFIG_HOME / "i3status-rust")

    # hypridle
    install(BASEDIR / "hypr" / "hypridle.conf",
            CONFIG_HOME / "hypr" / "hypridle.conf")

    # hyprlock
    install(BASEDIR / "hypr" / "hyprlock.conf",
            CONFIG_HOME / "hypr" / "hyprlock.conf")

    # hyprpaper
    install(BASEDIR / "hypr" / "hyprpaper.conf",
            CONFIG_HOME / "hypr" / "hyprpaper.conf")

    # hyprland
    install(BASEDIR / "hypr" / "hyprland.conf",
            CONFIG_HOME / "hypr" / "hyprland.conf")
    install(BASEDIR / "hypr" / "carbonfox.conf",
            CONFIG_HOME / "hypr" / "carbonfox.conf")
    install(BASEDIR / "hypr" / "carbonfox-oled.conf",
            CONFIG_HOME / "hypr" / "carbonfox-oled.conf")
    install(BASEDIR / "hypr" / "hologta.conf",
            CONFIG_HOME / "hypr" / "hologta.conf")
    install(BASEDIR / "hypr" / "catppuccin-macchiato.conf",
            CONFIG_HOME / "hypr" / "catppuccin-macchiato.conf")
    install(BASEDIR / "hypr" / "catppuccin-mocha.conf",
            CONFIG_HOME / "hypr" / "catppuccin-mocha.conf")
    install(BASEDIR / "hypr" / "catppuccin-mocha-oled.conf",
            CONFIG_HOME / "hypr" / "catppuccin-mocha-oled.conf")
    install(BASEDIR / "hypr" / "rose-pine.conf",
            CONFIG_HOME / "hypr" / "rose-pine.conf")
    install(BASEDIR / "hypr" / "rose-pine-oled.conf",
            CONFIG_HOME / "hypr" / "rose-pine-oled.conf")
    install(BASEDIR / "hypr" / "iceberg-tokyo.conf",
            CONFIG_HOME / "hypr" / "iceberg-tokyo.conf")
    install(BASEDIR / "hypr" / "tokyonight.conf",
            CONFIG_HOME / "hypr" / "tokyonight.conf")
    install(BASEDIR / "hypr" / "tokyonight-oled.conf",
            CONFIG_HOME / "hypr" / "tokyonight-oled.conf")

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

    # rio terminal emulator
    install(BASEDIR / "rio", CONFIG_HOME / "rio")

    # ghostty terminal emulator
    install(BASEDIR / "ghostty", CONFIG_HOME / "ghostty")

    # keyd key-remapping
    install(BASEDIR / "keyd" / "app.conf", CONFIG_HOME / "keyd" / "app.conf")

    # tofi launcher
    install(BASEDIR / "tofi", CONFIG_HOME / "tofi")

    # dunst notification daemon
    install(BASEDIR / "dunst", CONFIG_HOME / "dunst")

    # swappy
    install(BASEDIR / "swappy", CONFIG_HOME / "swappy")

    # Font
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
        BASEDIR / "fontconfig" / "conf.d" / "30-lilex.conf",
        CONFIG_HOME / "fontconfig" / "conf.d" / "30-lilex.conf",
    )
    install(
        BASEDIR / "fontconfig" / "conf.d" / "90-nerd-font-symbols-jp.conf",
        CONFIG_HOME / "fontconfig" / "conf.d" / "90-nerd-font-symbols-jp.conf",
    )

    # quickshell
    mkdir(CONFIG_HOME / "quickshell")
    git_clone("https://github.com/miyakogi/qs-dots", BASEDIR / "qs-dots")
    install(BASEDIR / "qs-dots", CONFIG_HOME / "quickshell" / "qs-dots")

    ####################
    # Systemd Services #
    ####################
    SERVICE_DIR = BASEDIR / "services"
    TARGET_DIR = CONFIG_HOME / "systemd" / "user"
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
    install_service("fnott.service")

    # for Sway
    install_service("swayidle.service")
    install_service("autotiling.service")

    # for Hyprland
    install_service("hypridle.service")


def install_other_home() -> None:
    """
    Create link of some directories between host's home and distrobox's home
    """
    logger.info("Link Distrobox Container and Host's HOME")

    # Some shareable xdg-directories
    HOST_CONFIG_HOME = HOST_HOME / ".config"
    install(HOST_CONFIG_HOME / "nvim" / "spell",
            CONFIG_HOME / "nvim" / "spell")
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
