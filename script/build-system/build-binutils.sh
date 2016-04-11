#!/bin/bash

# using     : build binutils
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# define variables
package_name="binutils"
source_file="binutils-2.25.1.tar.bz2"
source_dir="binutils-2.25.1"
ptys_req="spawn ls"
build_dir="binutils-build"

# log start
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# verify that ptys are workig
ptys_result=$(expect -c "spawn ls")
if [[ $ptys_result == $ptys_req ]]; then
    log_auto "ptys.verify" 0
else
    log_auto "ptys.verify" 1
fi

# create build directory
cd ../
rm -rfv $build_dir
mkdir -v $build_dir
cd $build_dir

# configure
log_auto "$package_name.configure.start" 0
../binutils-2.25.1/configure --prefix=/usr   \
   --enable-shared \
   --disable-werror
log_auto "$package_name.configure.finish" $?

# build
# build
log_auto "$package_name.make.start" 0
make tooldir=/usr
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
make check
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make tooldir=/usr install
log_auto "$package_name.install.finish" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
