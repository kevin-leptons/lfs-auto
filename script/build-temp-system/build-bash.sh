#!/bin/bash

# using     : build bash
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d bash-4.3.30 ]; then
   tar -xf bash-4.3.30.tar.gz
fi
cd bash-4.3.30

# configure
./configure --prefix=/tools --without-bash-malloc

# build
make

# test
make tests

# install
make install

# link
ln -sv bash /tools/bin/s
