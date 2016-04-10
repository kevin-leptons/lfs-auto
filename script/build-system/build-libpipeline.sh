#!/bin/bash

# using     : build libpipeline
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d libpipeline-1.4.1 ]; then
   tar -xf libpipeline-1.4.1.tar.gz
fi
cd libpipeline-1.4.1

# configure
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr &&

# build
make &&

# test
make check &&

# install
make install
