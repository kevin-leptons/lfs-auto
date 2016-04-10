#!/bin/bash

# using     : build autoconf
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d autoconf-2.69 ]; then
   tar -xf autoconf-2.69.tar.xz
fi
cd autoconf-2.69

# configure
./configure --prefix=/usr &&

# build
make &&

# test
make check &&

# install
make install
