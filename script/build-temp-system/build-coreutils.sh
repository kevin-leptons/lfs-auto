#!/bin/bash

# using     : build coreutils
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
package_name=coreutils
source_file=coreutils-8.24.tar.xz
source_dir=coreutils-8.24

# change working directory to sources directory
cd $root_sources

# log start setup
log_build "$package_name.setup.start" true

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
./configure --prefix=/tools --enable-install-program=hostname
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

# test
log_build "$package_name.test.start" true
make RUN_EXPENSIVE_TESTS=yes check
if [[ $? != 0 ]]; then
    log_build "$package_name.test.finish" false
    exit 1
else
    log_build "$package_name.test.finish" true
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
