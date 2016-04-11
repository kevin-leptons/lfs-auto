#!/bin/bash

# using     : build iproute
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

# variables
package_name="iproute"
source_file="iproute2-4.2.0.tar.xz"
source_dir="iproute2-4.2.0"

# log start
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# prepare
sed -i '/^TARGETS/s@arpd@@g' misc/Makefile &&
sed -i /ARPD/d Makefile &&
sed -i 's/arpd.8//' man/man8/Makefile
log_auto "$package_name.prepare" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
make DOCDIR=/usr/share/doc/iproute2-4.2.0 install
log_auto "$package_name.install.finish" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
