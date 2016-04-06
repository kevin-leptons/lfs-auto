#!/bin/bash

# using     : build coreutils
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d coreutils-8.24 ]; then
   tar -xf coreutils-8.24.tar.xz
fi
cd coreutils-8.24

# configure
./configure --prefix=/tools --enable-install-program=hostname

# build
make

# test
make RUN_EXPENSIVE_TESTS=yes check

# install
make install
