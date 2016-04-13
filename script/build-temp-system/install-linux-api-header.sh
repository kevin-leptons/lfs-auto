#!/bin/bash

# using     : install linux api header
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
package_name=linux
source_file=linux-4.2.tar.xz
source_dir=linux-4.2

# start
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract source code and change to source code directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# make sure there are no table files embedded in the packaged
make mrproper
log_auto "$package_name.make mrproper" $?

# install
log_auto "$package_name.install.start" 0
make INSTALL_HDR_PATH=dest headers_install
log_auto "$package_name.install.finish" $?

# copy headers
cp -rv dest/include/* /tools/include
log_auto "$package_name.copy headers" $?

# successfull
log_auto "$package_name.setup.finish" $?
exit 0
