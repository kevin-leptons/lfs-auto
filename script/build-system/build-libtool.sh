#!/bin/bash

# using     : build libtool
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d libtool-2.4.6 ]; then
   tar -xf libtool-2.4.6.tar.xz
fi
cd libtool-2.4.6

# configure
./configure --prefix=/usr &&

# build
make &&

# test
make check &&

# install
make install
