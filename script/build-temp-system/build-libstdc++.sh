#!/bin/bash

# using     : build libstdc++ package
# time      : 0.4 sbu
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
package_name=libstdcc++
source_file=gcc-5.2.0.tar.bz2
source_dir=gcc-5.2.0
build_dir=gcc-build

# log start setup
log_build "$package_name.setup.start" true

# verify source file
if [ ! -f $source_file ]; then
    log_build "$package_name.vefify" false
    exit 1
else
    log_build "$package_name.vefify" true
fi

# extract source code
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
rm -rf $build_dir
mkdir -vp $build_dir
cd $build_dir

# configure
log_build "$package_name.configure.start" true
../gcc-5.2.0/libstdc++-v3/configure \
    --host=$LFS_TGT                 \
    --prefix=/tools                 \
    --disable-multilib              \
    --disable-nls                   \
    --disable-libstdcxx-threads     \
    --disable-libstdcxx-pch         \
    --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/5.2.0
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

# successfull
log_build "$package_name.setup.finish" true
exit 0
