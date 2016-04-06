#!/bin/bash

# using     : install linux api headers
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources

# extract source code and change to source directory
if [ ! -d linux-4.2 ]; then
   tar -xf linux-4.2.tar.xz
fi
cd linux-4.2

# make sure there are no stale files and dependencies
make mrproper

# install
make INSTALL_HDR_PATH=dest headers_install &&
find dest/include \( -name .install -o -name ..install.cmd \) -delete &&
cp -rv dest/include/* /usr/include
