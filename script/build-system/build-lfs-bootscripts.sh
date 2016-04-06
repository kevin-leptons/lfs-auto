#!/bin/bash

# using     : build lfs-bootscripts
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d lfs-bootscripts-20150222 ]; then
   tar -xf lfs-bootscripts-20150222.tar.bz2
fi
cd lfs-bootscripts-20150222

# install
make install
