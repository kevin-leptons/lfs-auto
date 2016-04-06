#!/bin/bash

# using     : build tar
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d tar-1.28 ]; then
   tar -xf tar-1.28.tar.xz
fi
cd tar-1.28

# configure
FORCE_UNSAFE_CONFIGURE=1  \
./configure --prefix=/usr \
   --bindir=/bin &&

# build
make &&

# test
make check &&

# install
make install &&
make -C doc install-html docdir=/usr/share/doc/tar-1.28
