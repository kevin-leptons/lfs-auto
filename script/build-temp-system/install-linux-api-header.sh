#!/bin/bash

# using     : install linux api header
# time      : 0.1 sbu
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
package_name=linux
source_file=linux-4.2.tar.xz
source_dir=linux-4.2

# log start setup
log_build "$package_name.setup.start" true

# verify source_file
if [ ! -f $source_file]; then
    log_build "$package_name.verify" false
    exit 1
else
    log_build "$package_name.verify" true
fi

# extract source code and change to source code directory
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
cd $source_dir

# make sure there are no table files embedded in the packaged
make mrproper
if [[ $? != 0 ]]; then
    log_build "$package_name.make mrproper" false
    exit 1
else
    log_build "$package_name.make mrproper" true
fi

# install
log_build "$package_name.install.start" true
make INSTALL_HDR_PATH=dest headers_install
if [[ $? != 0 ]]; then
    log_build "$package_name.install.finish" false
    exit 1
else
    log_build "$package_name.install.finish" true
fi

# copy headers
cp -rv dest/include/* /tools/include
if [[ $? != 0 ]]; then
    log_build "$package_name.copy headers" false
else
    log_build "$package_name.copy headers" true
fi

# successfull
log_build "$package_name.setup.finish" true
exit 0
