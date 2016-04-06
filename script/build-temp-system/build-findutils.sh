#!/bin/bash

# using     : build gcc package in pass 1
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d findutils-4.4.2 ]; then
   tar -xf findutils-4.4.2.tar.gz
fi
cd findutils-4.4.2

# configure
./configure --prefix=/tools &&

# test
make check &&

# install
make install
