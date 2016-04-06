#!/bin/bash

# using     : build libstdc++ package
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# define variables
source_file=gcc-5.2.0.tar.bz2
source_dir=gcc-5.2.0
build_dir=gcc-build

# verify source file
if [ ! -f $source_file ] then
    echo "erorr: source file " $source_file " is not exist"
    echo $?
    exit 1
fi

# extract source code
if [ ! -d $source_dir ]; then
    tar -xf $source_file
    if $?; then
        echo "erorr: extract source file " $source_file
        echo $?
        exit 1
    fi
fi

# create and change to build directory
rm -rf $build_dir
mkdir -vp $build_dir
cd $build_dir

# configure
../gcc-5.2.0/libstdc++-v3/configure \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/5.2.0
if $?; then
    echo "erorr: configure " $source_file
    echo $?
    exit 1
fi

# build
make
if $?; then
    echo "erorr: make " $source_file
    echo $?
    exit 1
fi

# install
make install
if $?; then
    echo "erorr: make install " $source_file
    echo $?
    exit 1
fi

# successfull
exit 0
