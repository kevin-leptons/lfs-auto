#!/bin/bash

# using     : build sysvinit
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d sysvinit-2.88dsf ]; then
   tar -xf sysvinit-2.88dsf.tar.bz2
fi
cd sysvinit-2.88dsf

# patch
patch -Np1 -i ../sysvinit-2.88dsf-consolidated-1.patch &&

# build
make -C src &&

# install
make -C src install

