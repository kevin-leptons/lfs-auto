#!/bin/bash

# using     : build grep
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d grep-2.21 ]; then
   tar -xf grep-2.21.tar.xz
fi
cd grep-2.21

# configure
./configure --prefix=/tools &&

# build
make &&

# test
make check &&

# install 
make install
