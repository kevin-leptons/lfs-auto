#!/bin/bash

# using     : build libstdc++ package
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code
if [ ! -d gcc-5.2.0 ]; then
    tar -xf gcc-5.2.0.tar.bz2
fi

# create and change to build directory
rm -rf gcc-build &&
mkdir -vp gcc-build &&
cd gcc-build &&

../gcc-5.2.0/libstdc++-v3/configure \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/5.2.0 &&

# build
make &&

# install
make install
