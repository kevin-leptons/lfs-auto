#!/bin/bash

# using     : build util linux
# time      : 0.7 sbu
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
package_name=util-linux
source_file=util-linux-2.27.tar.xz
source_dir=util-linux-2.27

# change working directory to sources directory
cd $root_sources

# log start setup
log_build "$package_name.setup.start" true

# verify source code
if [ ! -f $source_file ]; then
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

# configure
log_build "$package_name.configure.start" true
./configure --prefix=/tools                \
            --without-python               \
            --disable-makeinstall-chown    \
            --without-systemdsystemunitdir \
            PKG_CONFIG=""
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
