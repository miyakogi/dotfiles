#!/usr/bin/env python3
# -*- coding: utf-8 -*-

'''
Install/Update/Check Vim Plugins
'''

import os
import json
import curses
import logging
import shutil
import argparse
from pathlib import Path
from itertools import chain
import subprocess
from typing import Union

PROTO = 'https'


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
        config = {'level': rec.levelname, 'name': rec.name, 'msg': rec.msg}
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


def setup_logger(logger):
    level = logging.DEBUG
    logger.setLevel(level)
    handler = logging.StreamHandler()
    handler.setLevel(level)
    handler.setFormatter(Formatter())
    logger.addHandler(handler)
    logger.propagate = False


logger = logging.getLogger('VimPack')
setup_logger(logger)

parser = argparse.ArgumentParser(description='Vim Package Helper')
parser.add_argument('command', choices=['install', 'update', 'check'])
parser.add_argument('config_file', default='pack.json', nargs='?')
parser.add_argument('--no-dummy', default=False, action='store_true',
        help='prevent making dummy files (plugin/_.vim)')
options = parser.parse_args()


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


def load_config_file(file:Union[Path, str]):
    if isinstance(file, Path):
        with file.open() as f:
            config = json.load(f)
    else:
        with open(file) as f:
            config = json.load(f)
    return config


def ensure_dir(path:Path):
    if not path.exists():
        path.mkdir()
        logger.info('{} created'.format(path))


def remove_if_broken(path:Path):
    if path.is_symlink() and not path.exists():
        logger.info('Delete broken symlink {}'.format(path))
        path.unlink()


def check_plugin_dir(path:Path):
    if options.no_dummy:
        return
    plugin_dir = path / 'plugin'
    if not plugin_dir.is_dir():
        logger.info('make plugin dir on {}'.format(path))
        plugin_dir.mkdir()
    empty = True
    for _ in plugin_dir.glob('*.vim'):
        empty = False
    if empty:
        logger.info('make dummy _.vim file on {}'.format(path.name))
        dummy_file = plugin_dir / '_.vim'
        dummy_file.touch()


def link_doc(path:Path):
    doc_dir = path / 'doc'
    vimdoc = VIMHOME / 'doc'
    for doc in chain(doc_dir.glob('*.txt'), doc_dir.glob('*.*x')):
        target =  vimdoc / doc.name
        remove_if_broken(target)
        if not target.exists():
            target.symlink_to(doc)


def post_process(path:Path):
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
    cmd = ['vim', '-u', 'NONE', '-N', '--cmd', vim_cmd]
    proc = subprocess.run(cmd)
    if proc.returncode == 0:
        logger.info('helptags done')
    else:
        logger.error('Failed to make helptags')


class Git:
    @classmethod
    def clone(self, repo:Path, base:Path):
        if Path.cwd() != base:
            os.chdir(str(base))
        target = base / repo.name
        if target.exists():
            logger.info('Skip existing {}'.format(target))
            return

        url = '{0}://{1}'.format(PROTO, repo)
        logger.info('start clone {}'.format(repo))
        proc = subprocess.run([
            'git', 'clone', '--recursive', url])
        if proc.returncode == 0:
            if target.is_dir():
                post_process(target)
            else:
                logger.warn('Cloned repository not found. Skip post-process.')
        else:
            logger.error('Failed to clone {}'.format(url))

    @classmethod
    def pull(cls, path:Path):
        if (path / '.git').exists():
            logger.info('Update {}/{}'.format(path.parent.name, path.name))
            os.chdir(str(path))
            proc = subprocess.run(['git', 'pull'])
            if proc.returncode == 0:
                cls.init_submodule(path)
                post_process(path)
            else:
                logger.error('error on `git pull` on {}'.format(path))
        else:
            logger.info('Skip non-git directory {}'.format(path))

    @classmethod
    def init_submodule(cls, path:Path):
        if Path.cwd() != path:
            os.chdir(str(path))
        subprocess.run(['git', 'submodule', 'update', '--init', '--recursive'])


class Packager:
    def __init__(self, config_file:Path):
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
            for plugin in base.iterdir():
                if plugin.is_dir():
                    post_process(plugin)
        logger.info('Check done')
        self.helptags()

    def helptags(self):
        helptags()


def find_config_file(filename:Path):
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
