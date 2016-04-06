#!/bin/bash

# using     : build auto-make
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d automake-1.15 ]; then
   tar -xf automake-1.15.tar.xz
fi
cd automake-1.15

# configure
./configure --prefix=/usr &&

# build
make &&

# test
make check &&

# install
make install
