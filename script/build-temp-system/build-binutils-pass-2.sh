#!/bin/bash

# using     : build binutils pacage in pass 2
# time      : 1.1 sbu
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

# define variable
package_name=binutils-pass-2
source_file= binutils-2.25.1.tar.bz2
source_dir=binutils-2.25.1

# change working directory to sources directory
cd $root_sources

# log start setup
log_build "$package_name.setup.start" true

# vefify
if [ ! -f $source_file ]; then
    log_build "$package_name.verify" false
else
    log_build "$package_name.verify" true
fi

# extract source code
if [ ! -d $source_dir ];then

    log_build "$package_name.extract.start" true

    tar -vxf $source_file

    if [[ $? != 0 ]]; then
        log_build "$package_name.extract.finish" false
        exit 1
    else
        log_build "$package_name.extract.finish" true
    fi
fi

# create and change to build directory
rm -rf binutils-build
mkdir -vp binutils-build
cd binutils-build

# configure
log_build "$package_name.configure.start" true
CC=$LFS_TGT-gcc                \
AR=$LFS_TGT-ar                 \
RANLIB=$LFS_TGT-ranlib         \
../binutils-2.25.1/configure     \
    --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot
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

# install
log_build "$package_name.install.start" true
make install
if [[ $? != 0 ]]; then
    log_build "$package_name.install.finish" false
    exit 1
else
    log_build "$package_name.install.finish" true
fi

# link
make -C ld clean &&
make -C ld LIB_PATH=/usr/lib:/lib &&
cp -v ld/ld-new /tools/bin
if [[ $? != 0 ]]; then
    log_build "$package_name.link" false
    exit 1
else
    log_build "$package_name.link" true
fi

# successfull
log_build "$package_name.setup.finish" true
exit 0
