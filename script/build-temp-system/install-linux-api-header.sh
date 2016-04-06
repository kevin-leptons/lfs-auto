#!/bin/bash

# using     : install linux api header
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
source_file=linux-4.2.tar.xz
source_dir=linux-4.2

# verify source_file
if [ ! -f $source_file]; then
    echo "error: source file " $source_file " is not exists"
fi

# extract source code and change to source code directory
if [ ! -d $source_dir ]; then
   tar -xf $source_file
   if $?; then
       echo "error: extract source file " $source_file
       echo $?
       exit 1
   fi
fi
cd $source_dir

# make sure there are no table files embedded in the packaged
make mrproper
if $?; then
    echo "error: make mrproper " $source_file
    echo $?
    exit 1
fi

# install
make INSTALL_HDR_PATH=dest headers_install
if $?; then
    echo "error: install " $source_file
    echo $?
    exit 1
fi

cp -rv dest/include/* /tools/include

# successfull
exit 0
