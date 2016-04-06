#!/bin/bash

# using     : build binutils pacage in pass 2
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code
if [ ! -d binutils-2.25.1 ];then
    tar -xf binutils-2.25.1.tar.bz2
fi

# create and change to build directory
rm -rf binutils-build &&
mkdir -vp binutils-build &&
cd binutils-build &&

# configure
CC=$LFS_TGT-gcc                \
AR=$LFS_TGT-ar                 \
RANLIB=$LFS_TGT-ranlib         \
../binutils-2.25.1/configure     \
    --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot

# build
make

# install
make install

# link
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin
