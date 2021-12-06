#!/usr/bin/env python3

"""
MPDCover: Terminal MPD Cover/Album Art Viewer (WIP)
===================================================

Suppored Platform
-----------------

* Linux (Arch Linux)
* Python >= 3.9
* Kitty (terminal emulator)

Might work on other platforms, but don't expect any support.

Video thumbnail feature is very limitted and only works on local machine.

Install
-------

Git version (currently not pushed yet):

    pip install git+https://github.com/***/mpdcover.git

or, manually install dependencies and then run `python mpdcover.py`.

### Dependencies

* python-mpd2
* imagemagick (kitty's icat support)
* ffmpegthumbnailer (video thumbnail support)

Usage
-----

Run MPD server and play song, and then run:

    mpdcover

Or:

    python mpdcover.py

To terminate, press `q` or `Ctrl+c`.

### Options

* `--help`: show help
* `--directory`: set MPD's music directory [default: `~/Music`]
* `--host`: set MPD server's address [default: `localhost`]
* `--port`: set MPD server's port [default: `6600`]

Example:

    mpdcover --directory "~/My Music" --host 192.168.0.1 --port 6666

Trouble Shooting
----------------

* Does not show images on some music files.
  * Ensure that cover art (album art) images are embedded in the music files.
    If not, for example, use [`beets`](http://beets.io/) and its `fetchart`
    and `embedart` plugins to find and embed images to the music files.

* Does not work on tmux/screen.
  * Kitty's image display protocol may not work within a terminal multiplexer.
    See [Kitty's Document](https://sw.kovidgoyal.net/kitty/kittens/icat.html).

License
-------

Apache 2.0: (c) 2021 Miyaco

"""

import argparse
import curses
import enum
import mimetypes
import multiprocessing as mp
import shutil
from os import path
import subprocess
import tempfile
from typing import Any, Union

from mpd import MPDClient, CommandError, ConnectionError

parser = argparse.ArgumentParser(
    prog='mpdcover',
    description='Terminal MPD Cover/Album Art Viewer',
    formatter_class=argparse.ArgumentDefaultsHelpFormatter,
)
parser.add_argument(
    '--directory', type=str, nargs='?',
    default='~/Music',
    help="MPD's music file directory",
)
parser.add_argument(
    '--host', type=str, nargs='?',
    default='localhost',
    help="MPD server's host address",
)
parser.add_argument(
    '--port', type=int, nargs='?',
    default=6600,
    help="MPD server's port",
)


class Command(enum.Enum):
    STOP = enum.auto()
    UPDATE = enum.auto()
    RESIZE = enum.auto()


class Song(enum.Enum):
    SAME = enum.auto()


def connect(host: str, port: int) -> MPDClient:
    client = MPDClient()
    client.timeout = None
    client.idletimeout = None
    client.connect(host, port)
    return client


def mpd_watcher(q: mp.Queue, host: str, port: int) -> None:
    client = connect(host, port)

    try:
        while True:
            client.idle('player', 'playlist')
            q.put(Command.UPDATE)
    except (KeyboardInterrupt, InterruptedError):
        pass
    finally:
        client.close()
        client.disconnect()


def key_watcher(q: mp.Queue, win: Any) -> None:
    while True:
        ch = win.getch()
        if ch == curses.KEY_RESIZE:
            q.put(Command.RESIZE)
        elif ch == ord('q'):
            q.put(Command.STOP)
            break


class Client(object):
    def __init__(self, directory: str, host: str, port: int) -> None:
        self.temp_dir = tempfile.TemporaryDirectory()
        self.current_file = ''
        self.current_image = ''
        self.stopped = False
        self.queue: mp.Queue[Command] = mp.Queue(0)

        self.music_dir = path.expanduser(directory)
        self.host = host
        self.port = port

    def close(self) -> None:
        # terminate watcher processes
        self.mpd_watcher.terminate()
        self.key_watcher.terminate()
        self.mpd_watcher.join()
        self.key_watcher.join()

        # show cursor and restore terminal state
        curses.nocbreak()
        self.win.keypad(False)
        curses.echo()
        curses.endwin()
        subprocess.run(['clear'])

        # close mpd client
        self.client.close()
        self.client.disconnect()

    def start(self) -> None:
        # clear and setup terminal
        subprocess.run(['clear'])
        self.win = curses.initscr()
        curses.noecho()
        curses.cbreak()
        self.win.keypad(True)
        self.win.nodelay(False)

        # setup main mpd client
        self.client = connect(self.host, self.port)

        # setup mpd watcher process
        self.mpd_watcher = mp.Process(
            target=mpd_watcher,
            args=(self.queue, self.host, self.port),
        )
        self.mpd_watcher.start()

        # setup key watcher process
        self.key_watcher = mp.Process(
            target=key_watcher,
            args=(self.queue, self.win),
        )
        self.key_watcher.start()

        # hide cursor
        curses.curs_set(0)

        try:
            while True:
                self.show_coverart(force=False)
                command = self.queue.get()
                if command == Command.UPDATE:
                    continue
                elif command == Command.RESIZE:
                    self.show_coverart(force=True)
                    continue
                elif command == Command.STOP:
                    break
        except KeyboardInterrupt:
            pass

    @property
    def version(self) -> str:
        return self.client.mpd_version

    @property
    def status(self) -> dict:
        try:
            return self.client.status()
        except ConnectionError:
            self.client = connect(self.host, self.port)
            return self.client.status()

    @property
    def state(self) -> str:
        return self.status['state']

    @property
    def currentsong(self) -> dict:
        if self.state in ['play', 'pause']:
            song = self.client.currentsong()
            return song
        return dict()

    def get_coverart(self, force: bool = False) -> Union[None, str, Song]:
        if self.state not in ['play', 'pause']:
            return None

        song = self.currentsong
        song_file_base = song.get('file', '')

        if song_file_base == self.current_file:
            if not force:
                return Song.SAME
            else:
                return self.current_image
        self.current_file = song_file_base

        try:
            image_dict = self.client.readpicture(song_file_base)
        except CommandError:
            image_dict = {}

        if image_dict:
            # get embedded image
            ext = mimetypes.guess_extension(image_dict['type'])
            image_file = path.join(self.temp_dir.name, f'mpdcover-image{ext}')
            with open(image_file, 'wb') as f:
                f.write(image_dict['binary'])
            self.current_image = image_file
            return image_file

        mime, _ = mimetypes.guess_type(path.basename(song_file_base))
        if mime is None:
            return None

        if mime.startswith('audio'):
            # get cover image file place in the album directory
            song_dir = path.dirname(path.join(self.music_dir, song_file_base))
            cover_file_jpeg = path.join(song_dir, 'cover.jpg')
            cover_file_png = path.join(song_dir, 'cover.png')
            if path.exists(cover_file_jpeg):
                self.current_image = cover_file_jpeg
                return cover_file_jpeg
            elif path.exists(cover_file_png):
                self.current_image = cover_file_png
                return cover_file_png
            else:
                return None

        if mime.startswith('video'):
            # generate thumbnail of the video
            if not shutil.which('ffmpegthumbnailer'):
                print(
                    'ffmpegthumbnailer is required for video file thumbnail.')
                return None

            song_file = path.join(self.music_dir, song_file_base)
            image_file = path.join(self.temp_dir.name, 'mpdcover-image.jpg')
            commands = [
                'ffmpegthumbnailer',
                '-i', song_file,
                '-o', image_file,
                '-s', '0',
            ]

            subprocess.run(
                commands,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )

            if not path.exists(image_file):
                return None
            self.current_image = image_file
            return image_file

        return None

    def show_coverart(self, force: bool = False) -> None:
        if self.state not in ['play', 'pause']:
            self.stopped = True
            subprocess.run(['clear'])
            self.win.erase()
            self.win.addstr('MPD is not playing, waiting...')
            self.win.refresh()
            return

        image_file = self.get_coverart(force or self.stopped)
        self.stopped = False
        if image_file is Song.SAME:
            return

        subprocess.run(['clear'])
        self.win.erase()
        self.win.refresh()

        if image_file is None:
            song = self.currentsong
            file = path.basename(song.get('file', 'Not Found'))
            self.win.addstr(0, 0, '[Cover Art not Found]', curses.A_BOLD)
            self.win.addstr(1, 0, f'Title: {song.get("title", "Unknown")}')
            self.win.addstr(2, 0, f'Artist: {song.get("artist", "Unknown")}')
            self.win.addstr(3, 0, f'File: {file}')
            self.win.refresh()
            return

        width, height = shutil.get_terminal_size()
        subprocess.run([
            'kitty', 'icat',
            '--transfer-mode', 'stream',
            '--scale-up',
            '--place', f'{width}x{height}@{0}x{0}',
            image_file,
        ])


def check_term() -> bool:
    proc = subprocess.run([
        'kitty', 'icat', '--detect-support', '--detection-timeout', '1',
    ])
    return proc.returncode == 0


def main() -> None:
    if not check_term():
        print('mpdcover only supports kitty terminal')
        exit(1)

    options = parser.parse_args()
    client = Client(**vars(options))

    try:
        client.start()
    finally:
        client.close()


if __name__ == '__main__':
    main()
