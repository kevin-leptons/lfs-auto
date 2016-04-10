#!/bin/bash

# using     : build zlib
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d zlib-1.2.8 ]; then
   tar -xf zlib-1.2.8.tar.xz
fi
cd zlib-1.2.8 &&

# configure
./configure --prefix=/usr &&

# build
make &&

# test
make check &&

# install
make install &&

# link
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
