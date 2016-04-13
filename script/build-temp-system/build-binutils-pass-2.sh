#!/bin/bash

# using     : build binutils pacage in pass 2
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

# variable
package_name="binutils-pass-2"
source_file="binutils-2.25.1.tar.bz2"
source_dir="binutils-2.25.1"
build_dir="binutils-build"

# start
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" $?
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
rm -rf $build_dir
mkdir -vp $build_dir
cd $build_dir

# configure
log_auto "$package_name.configure.start" 0
CC=$LFS_TGT-gcc                \
AR=$LFS_TGT-ar                 \
RANLIB=$LFS_TGT-ranlib         \
../binutils-2.25.1/configure     \
    --prefix=/tools            \
    --disable-nls              \
    --disable-werror           \
    --with-lib-path=/tools/lib \
    --with-sysroot
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# link
make -C ld clean &&
make -C ld LIB_PATH=/usr/lib:/lib &&
cp -v ld/ld-new /tools/bin
log_auto "$package_name.link" $?

# successfull
log_auto "$package_name.setup.finish" $?
exit 0
