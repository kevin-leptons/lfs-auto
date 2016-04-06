#!/bin/bash

# using     : build binutils package in pass 1
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# change working directory to sources directory
cd $root_sources

# define variables
package_name=binutils-pass-1
source_file=binutils-2.25.1.tar.bz2
source_dir=binutils-2.25.1
build_dir=binutils-build

# log start setup
log_build "$package_name.start" true

# verify source code
if [ ! -f $source_file ]; then
    log_build "$package_name.verify" false
    exit 1
else
    log_build "$package_name.verify" true
fi

# extract source file
if [ ! -d $source_dir ]; then
    log_build "$package_name.extract.start" true
    tar -vxf $source_file
    if [[ $? != 0 ]]; then
        log_build "$package_name.extract.finish" false
        exit 1
    else
        log_build "$package_name.extract.finish" true
    fi
else
    log_build "$package_name.extract.idle" true
fi

# create and change to build directory
mkdir -vp $build_dir
cd $build_dir

# configure
log_build "$package_name.configure.start" true
../binutils-2.25.1/configure \
    --prefix=/tools \
    --with-sysroot=$LFS \
    --with-lib-path=/tools/lib \
    --target=$LFS_TGT \
    --disable-nls \
    --disable-werror
if [[ $? != 0 ]]; then
    log_build "$package_name.configure.finish" false
    exit 1
else
    log_build "$package_name.configure.finish" true
fi

# build
log_build "$package_name.make.start" true
make
if [[ $? != 0 ]]; then
    log_build "$package_name.make.finish" false
    exit 1
else
    log_build "$package_name.make.finish" true
fi

# create x64 directory
case $(uname -m) in
    x86_64) \

    mkdir -v /tools/lib;
    if $?; then
        log_build "$package_name.create x64 directory" false
    fi

    ln -sv lib /tools/lib64;;
esac

# install
log_build "$package_name.install.start" true
make install
if [[ $? != 0 ]]; then
    log_build "$package_name.install.finish" false
    exit 1
else
    log_build "$package_name.install.finish" true
fi

# successfull
log_build "$package_name.finish" true
exit 0
