#!/bin/bash

# using     : build check
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d check-0.10.0 ]; then
   tar -xf check-0.10.0.tar.gz
fi
cd check-0.10.0

# prepare
PKG_CONFIG= ./configure -- prefix=/tools

# build
make

# test
make check

# install
make install
