#!/bin/bash

# using     : build texinfo
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d texinfo-6.0 ]; then
   tar -xf texinfo-6.0.tar.xz
fi
cd texinfo-6.0

# configure
./configure --prefix=/tools &&

# make
make &&

# test
make check

# install
make install
