#!/bin/bash

# using     : build dejagnu
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
package_name="dejagnu"
source_file="dejagnu-1.5.3.tar.gz"
source_dir="dejagnu-1.5.3"

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

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/tools
log_auto "$package_name.configure.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# test
log_auto "$package_name.test.start" 0
make check
log_build "$package_name.test.finish" $?

# successfull
log_build "$package_name.setup.finish" $?
exit 0
