#!/usr/bin/env bash

cd cpython

make distclean
install_dir=$HOME/opt

# Install python2
version=2.7.13
pydir=$install_dir/python-$version

git checkout v$version

./configure \
	--prefix=$pydir \
	--enable-shared \
	LDFLAGS=-Wl,-rpath,$pydir/lib

make -j 4
make install

make distclean

# Install pip for python2
# curl -kL https://raw.github.com/pypa/pip/master/contrib/get-pip.py | \
# 	$pydir/bin/python

# Install python3
version=3.6.2
pydir=$install_dir/python-$version

git checkout v$version

./configure \
	--prefix=$pydir \
	--enable-shared \
	LDFLAGS=-Wl,-rpath,$pydir/lib
make -j 4
make install
if [ -e $pydir/bin/python ]; then
  rm $pydir/bin/python
fi
ln -s $pydir/bin/python3 $pydir/bin/python
ln -s $pydir/bin/pip3 $pydir/bin/pip
make distclean
