#!/bin/bash

# using     : build dejagnu
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d dejagnu-1.5.3 ]; then
   tar -xf dejagnu-1.5.3.tar.gz 
fi
cd dejagnu-1.5.3

# configure
./configure --prefix=/tools

# install
make install

# test
make check
