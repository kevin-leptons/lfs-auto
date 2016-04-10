#!/bin/bash

# using     : build mpc
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d mpc-1.0.3 ]; then
   tar -xf mpc-1.0.3.tar.gz
fi
cd mpc-1.0.3

# configure
./configure --prefix=/usr    \
   --disable-static \
   --docdir=/usr/share/doc/mpc-1.0.3 &&

# build
make &&
make html &&

# test
make check &&

# install
make install &&
make install-html
