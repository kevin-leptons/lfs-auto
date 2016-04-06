#!/bin/bash

# using     : build util linux
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d util-linux-2.27 ]; then
   tar -xf util-linux-2.27.tar.xz
fi
cd util-linux-2.27

# configure
./configure --prefix=/tools                \
            --without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            PKG_CONFIG=""

# build
make

# install
make install
