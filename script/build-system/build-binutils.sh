#!/bin/bash

# using     : build binutils
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d binutils-2.25.1 ]; then
   tar -xf binutils-2.25.1.tar.bz2
fi
cd binutils-2.25.1

# verify that ptys are workig
expect -c "spawn ls"

# create build directory
cd ../
rm -rfv binutils-build
mkdir -v binutils-build
cd binutils-build

# configure
../binutils-2.25.1/configure --prefix=/usr   \
   --enable-shared \
   --disable-werror &&

# build
make tooldir=/usr &&

# test
make check &&

# install
make tooldir=/usr install
