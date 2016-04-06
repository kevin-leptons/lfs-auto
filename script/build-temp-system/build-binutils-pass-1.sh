#!/bin/bash

# using     : build binutils package in pass 1
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
mkdir -vp binutils-build &&
cd binutils-build &&

# configure and build package
../binutils-2.25.1/configure \
    --prefix=/tools \
    --with-sysroot=$LFS \
    --with-lib-path=/tools/lib \
    --target=$LFS_TGT \
    --disable-nls \
    --disable-werror
make

# create x64 directory
case $(uname -m) in
    x86_64) mkdir -v /tools/lib; ln -sv lib /tools/lib64;;
esac

# install package to lfs partition
make install
