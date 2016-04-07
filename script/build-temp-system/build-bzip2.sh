#!/bin/bash

# using     : build bzip2
# time      : less than 0.1 sbu
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
package_name=bzip2
source_file=bzip2-1.0.6.tar.gz
source_dir=bzip2-1.0.6

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d $source_dir ]; then
   tar -vxf $source_file
fi
cd $source_dir

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
make PREFIX=/tools install
if [[ $? != 0 ]]; then
    log_build "$package_name.install.finish" false
    exit 1
else
    log_build "$package_name.install.finish" true
fi

# successfull
log_build "$package_name.setup.finish" true
exit 0
