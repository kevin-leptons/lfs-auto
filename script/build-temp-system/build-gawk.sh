#!/bin/bash

# using     : build gawk
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d gawk-4.1.3 ]; then
   tar -xf gawk-4.1.3.tar.xz
fi
cd gawk-4.1.3

# configure
./configure --prefix=/tools

# build
make

# test
make check

# install
make install
