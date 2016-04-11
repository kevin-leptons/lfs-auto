#!/bin/bash

# using     : build man page
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
package_name="man-pages"
source_file="man-pages-4.02.tar.xz"
source_dir="man-pages-4.02"

# change working directory to sources directory
cd /sources

# log start
log_auto "$package_name.setup.start" 0

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file 
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# successfully
exit 0
