#!/bin/bash

# using     : build sysklogd
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
package_name="sysklogd"
source_file="sysklogd-1.5.1.tar.gz"
source_dir="sysklogd-1.5.1"

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

# fix a problem that causes a segmentation fault
sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
log_auto "$package_name.segmentation-fault.fix" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
make BINDIR=/sbin install
log_auto "$package_name.install.finish" $?

# create /etc/syslog.conf
cp -vp /lfs-script/asset/syslog.conf /etc/syslog.conf
log_auto "/etc/syslog.conf.create" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
