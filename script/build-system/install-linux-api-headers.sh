#!/bin/bash

# using     : install linux api headers
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

# define variables
package_name="linux"
source_file=linux-4.2.tar.xz
source_dir=linux-4.2

# change working directory to sources directory
cd /sources

# log start
log "$package_name.setup.start" true

# extract source code and change to source directory
if [ ! -d $source_dir ]; then

    log "$package_name.extract.start" true

    tar -vxf $source_file

    if [[ $? != 0 ]]; then
        log "$package_name.extract.finish" false
        exit 1
    else
        log "$package_name.extract.finish" true
    fi
else
    log "$package_name.extract.idle" true
fi
cd $source_dir

# make sure there are no stale files and dependencies
make mrproper
if [[ $? != 0 ]]; then
    log "$package_name.mrproper" false
    exit 1
else
    log "$package_name.mrproper" true
fi

# install
make INSTALL_HDR_PATH=dest headers_install &&
find dest/include \( -name .install -o -name ..install.cmd \) -delete &&
cp -rv dest/include/* /usr/include
if [[ $? != 0 ]]; then
    log "$package_name.install" false
    exit 1
else
    log "$package_name.install" true
fi

# successfully
log "$package_name.setup.finish" true
exit 0
