#!/bin/bash

# using     : build flex
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d flex-2.5.39 ]; then
   tar -xf flex-2.5.39.tar.xz
fi
cd flex-2.5.39

# skip three regression tests that require bison
sed -i -e '/test-bison/d' tests/Makefile.in &&

# configure
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.5.39 &&

# build
make &&

# test
make check &&

# install
make install &&

# link
ln -sv flex /usr/bin/lex
