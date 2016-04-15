#!/bin/bash

# using     : build bzip2
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
package_name="bzip2"
source_file="bzip2-1.0.6.tar.gz"
source_dir="bzip2-1.0.6"

# start
log "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log "$package_name.verify" 0
else
    log "$package_name.verify" 1
fi

# extract source code and change to source code directory
if [ -d $source_dir ]; then
    log "$package_name.extract.idle" 0
else
    log "$package_name.extract.start" 0
    tar -vxf $source_file
    log "$package_name.extract.finish" $?
fi
cd $source_dir

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# install
log "$package_name.install.start" 0
make PREFIX=/tools install
log "$package_name.install.finish" $?

# successfull
log "$package_name.setup.finish" $?
exit 0
