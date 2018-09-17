#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Install/Update/Check Vim Plugins

The MIT License (MIT)

Copyright (c) 2016 miyakogi

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
'''

import json
import curses
import logging
import shutil
import argparse
from pathlib import Path
from itertools import chain
import subprocess
from typing import Union
import sys

PROTO = 'https'


# Make option parser
parser = argparse.ArgumentParser(description='Vim Package Helper')
parser.add_argument('command', choices=['install', 'update', 'check'])
parser.add_argument('config_file', default='pack.json', nargs='?')
parser.add_argument('--no-dummy', default=False, action='store_true',
                    help='prevent making dummy files (plugin/_.vim)')
parser.add_argument('--no-doc', default=False, action='store_true',
                    help='prevent making symlinks of help '
                    '(doc/*.{txt,*x} to ~/.vim/doc)')
parser.add_argument('--loglevel', default='info',
                    help='Available levels are {} (case insensitive)'.format(
                        list(logging._nameToLevel.keys())))

# Parse command-line options
options = parser.parse_args()


class Formatter(logging.Formatter):
    _colors_int = {'red': 1, 'green': 2, 'orange': 3, 'blue': 4}

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.colors = {}
        curses.setupterm()
        try:
            self.colors['normal'] = curses.tigetstr('sgr0').decode('utf-8')
            for color, val in self._colors_int.items():
                self.colors[color] = curses.tparm(
                    curses.tigetstr('setaf'), val).decode('utf-8')
        except Exception:
            self.colors['normal'] = ''
            for color in self._colors_int:
                self.colors[color] = ''

    def format(self, rec):
        fmt = '{color}[{level}:{name}]{normal} {msg}'
        config = {'level': rec.levelname[0], 'name': rec.name, 'msg': rec.msg}
        if rec.levelno >= logging.ERROR:
            config['color'] = self.colors['red']
        elif rec.levelno >= logging.WARN:
            config['color'] = self.colors['orange']
        elif rec.levelno >= logging.INFO:
            config['color'] = self.colors['green']
        elif rec.levelno >= logging.DEBUG:
            config['color'] = self.colors['blue']
        else:
            config['color'] = ''
        config['normal'] = self.colors['normal']
        return fmt.format(**config)


# Make logger
logger = logging.getLogger('vimpack')
level = getattr(logging, options.loglevel.upper())
logger.setLevel(level)
handler = logging.StreamHandler()
handler.setLevel(level)
handler.setFormatter(Formatter())
logger.addHandler(handler)
logger.propagate = False


def check_commands():
    if not shutil.which('git'):
        raise OSError('git command not found')


def find_vimhome():
    unix_style_vimhome = Path.home() / '.vim'
    win_style_vimhome = Path.home() / '_vim'
    if unix_style_vimhome.exists():
        return unix_style_vimhome
    if win_style_vimhome.exists():
        return win_style_vimhome
    raise FileNotFoundError('~/.vim or ~/_vim not found.')


VIMHOME = find_vimhome()


def load_config_file(file: Union[Path, str]):
    if isinstance(file, Path):
        with file.open() as f:
            config = json.load(f)
    else:
        with open(file) as f:
            config = json.load(f)
    return config


def ensure_dir(path: Path):
    if not path.exists():
        path.mkdir()
        logger.info('{} created'.format(path))


def remove_if_broken(path: Path):
    if path.is_symlink() and not path.exists():
        logger.info('Delete broken symlink {}'.format(path))
        path.unlink()


def check_plugin_dir(path: Path):
    if options.no_dummy:
        return
    plugin_dir = path / 'plugin'
    if not plugin_dir.is_dir():
        logger.debug('make plugin dir on {}'.format(path))
        plugin_dir.mkdir()
    empty = True
    for _ in plugin_dir.glob('*.vim'):
        empty = False
    if empty:
        logger.debug('make dummy _.vim file on {}'.format(path.name))
        dummy_file = plugin_dir / '_.vim'
        dummy_file.touch()


def link_doc(path: Path):
    if options.no_doc:
        return
    doc_dir = path / 'doc'
    vimdoc = VIMHOME / 'doc'
    for doc in chain(doc_dir.glob('*.txt'), doc_dir.glob('*.*x')):
        target = vimdoc / doc.name
        remove_if_broken(target)
        if not target.exists():
            logger.debug('make symlink {} -> {}'.format(target, doc))
            if not sys.platform.startswith('win'):
                target.symlink_to(doc)
            else:
                import ctypes
                kdll = ctypes.windll.LoadLibrary('kernel32.dll')
                kdll.CreateSymbolicLinkW(str(doc), str(target), 1)


def post_process(path: Path):
    if path.is_dir() and path.is_absolute():
        check_plugin_dir(path)
        link_doc(path)


def clean_doc():
    doc_dir = VIMHOME / 'doc'
    if doc_dir.is_dir():
        for doc in doc_dir.iterdir():
            remove_if_broken(doc)


def helptags():
    clean_doc()
    vim_cmd = 'helptags {} | quitall'.format(VIMHOME / 'doc')
    vim_cmd  =  vim_cmd.replace('\\', '/')
    cmd = ['vim', '-u', 'NONE', '-N', '--cmd', vim_cmd]
    proc = subprocess.run(cmd)
    if proc.returncode == 0:
        logger.info('helptags done')
    else:
        logger.error('Failed to make helptags')


class Git:
    @classmethod
    def clone(self, repo: Path, base: Path):
        target = base / repo.name
        if target.exists():
            logger.debug('Skip existing {}'.format(target))
            return

        url = '{0}://{1}'.format(PROTO, repo.as_posix())
        logger.info('start clone {}'.format(repo))
        proc = subprocess.run(['git', 'clone', '--recursive', url],
                              cwd=str(base))
        if proc.returncode == 0:
            if target.is_dir():
                post_process(target)
            else:
                logger.warn('Cloned repository not found. Skip post-process.')
        else:
            logger.error('Failed to clone {}'.format(url))

    @classmethod
    def pull(cls, path: Path):
        if (path / '.git').exists():
            logger.info('Update {}/{}'.format(path.parent.name, path.name))
            proc = subprocess.run(['git', 'pull'], cwd=str(path))
            if proc.returncode == 0:
                cls.init_submodule(path)
                post_process(path)
            else:
                logger.error('error on `git pull` on {}'.format(path))
        else:
            logger.debug('Skip non-git directory {}'.format(path))

    @classmethod
    def init_submodule(cls, path: Path):
        subprocess.run(['git', 'submodule', 'update', '--init', '--recursive'],
                       cwd=str(path))


class Packager:
    def __init__(self, config_file: Path):
        self.dir = config_file.parent
        self.config = load_config_file(config_file)

    def install(self):
        check_commands()
        for d in self.config:
            ensure_dir(self.dir / d)
            base = self.dir / d
            for domain in self.config[d]:
                host = Path(domain)
                for repo in self.config[d][domain]:
                    Git.clone(host / repo, base)
        logger.info('Install completed')
        self.helptags()

    def update(self):
        check_commands()
        for d in self.config:
            ensure_dir(self.dir / d)
            base = self.dir / d
            for plugin_dir in base.iterdir():
                if plugin_dir.is_dir():
                    Git.pull(plugin_dir)
        logger.info('Update completed')
        self.helptags()

    def check(self):
        ensure_dir(VIMHOME / 'doc')
        for d in self.config:
            base = self.dir / d
            managed_plugins = []
            unmanaged_plugins = []
            for host in self.config[d]:
                managed_plugins.extend(
                        Path(repo).name for repo in self.config[d][host])
            for plugin in base.iterdir():
                if plugin.is_dir():
                    if plugin.name in managed_plugins:
                        managed_plugins.remove(plugin.name)
                    else:
                        unmanaged_plugins.append(plugin.name)
                    post_process(plugin)
            if unmanaged_plugins:
                logger.warn('({}/{}) plugins not in config file: {}'.format(
                    base.parts[-2], base.parts[-1], unmanaged_plugins))
            if managed_plugins:
                logger.warn('({}/{}) not installed plugins: {}'.format(
                    base.parts[-2], base.parts[-1], managed_plugins))
        logger.info('Check done')
        self.helptags()

    def helptags(self):
        helptags()


def find_config_file(filename: Path):
    conf_files = []
    for pack in (VIMHOME / 'pack').iterdir():
        if (pack / filename).exists():
            conf_files.append(pack / filename)
    return conf_files


def main():
    conf = Path(options.config_file)

    if conf.is_absolute():
        conf_files = [conf]
    else:
        conf_files = find_config_file(conf)
    if not conf_files:
        logger.error('{} not found in any directories under {}'.format(
            conf, VIMHOME / 'pack'))
        return

    for conf_file in conf_files:
        packager = Packager(conf_file)
        getattr(packager, options.command)()


if __name__ == '__main__':
    main()
