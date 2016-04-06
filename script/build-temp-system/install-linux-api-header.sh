#!/bin/bash

# using     : install linux api header
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d linux-4.2 ]; then
   tar -xf linux-4.2.tar.xz
fi
cd linux-4.2 &&

# make sure there are no table files embedded in the packaged
make mrproper

# install header
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include
