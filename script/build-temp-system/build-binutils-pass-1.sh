#!/bin/bash

# using     : build binutils package in pass 1
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
source_file=binutils-2.25.1.tar.bz2
source_dir=binutils-2.25.1
build_dir=binutils-build

# verify source code
if [ ! -f $source_file ]; then
    echo "error: " $source_file " is not exists"
    exit 1
fi

# extract source file
if [ ! -d $source_dir ]; then
    if tar -xf $source_file > /dev/null 2>&1; then
        echo "error: extract source file " $source_file
        echo $?
        exit 1
    fi
fi

# create and change to build directory
mkdir -vp $build_dir &&
cd $build_dir &&

# configure
../binutils-2.25.1/configure \
    --prefix=/tools \
    --with-sysroot=$LFS \
    --with-lib-path=/tools/lib \
    --target=$LFS_TGT \
    --disable-nls \
    --disable-werror
if $?; then
    echo "error: configure " $source_file
    echo $?
fi

# build
make
if $?; then
    echo "error: make " $source_file
    echo $?
fi

# create x64 directory
case $(uname -m) in

    x86_64) mkdir -v /tools/lib; ln -sv lib /tools/lib64;;

    if $?; then
        echo "error: create x64 directory"
        echo $?
    fi
esac

# install
make install
if $?; then
    echo "error: install " $source_file
    echo $?
fi

# successfull
exit 0
