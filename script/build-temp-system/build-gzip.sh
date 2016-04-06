#!/bin/bash

# using     : build gzip
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d gzip-1.6 ]; then
   tar -xf gzip-1.6.tar.xz
fi
cd gzip-1.6

# configure
./configure --prefix=/tools &&

# build
make &&

# test
make check

# install
make install
