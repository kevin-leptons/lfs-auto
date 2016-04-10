#!/bin/bash

# using     : build gdbm
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d gdbm-1.11 ]; then
   tar -xf gdbm-1.11.tar.gz
fi
cd gdbm-1.11

# configure
./configure --prefix=/usr \
   --disable-static \
   --enable-libgdbm-compat &&

# build
make &&

# test
make check &&

# install
make install
