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

# variables
package_name="binutils-pass-1"
source_file="binutils-2.25.1.tar.bz2"
source_dir="binutils-2.25.1"
build_dir="binutils-build"

# log start setup
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.finish" $?
fi

# create and change to build directory
mkdir -vp $build_dir
cd $build_dir

# configure
log_auto "$package_name.configure.start" 0
../binutils-2.25.1/configure \
    --prefix=/tools \
    --with-sysroot=$LFS \
    --with-lib-path=/tools/lib \
    --target=$LFS_TGT \
    --disable-nls \
    --disable-werror
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# create x64 directory
case $(uname -m) in
    x86_64) \

    mkdir -v /tools/lib;
    ln -sv lib /tools/lib64;
    log_auto "$package_name.x64-directory.mkdir" $?;;
esac

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# successfull
log_auto "$package_name.setup.finish" $?
exit 0
