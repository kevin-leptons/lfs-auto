#!/bin/bash

# using     : build perl
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
package_name="perl"
source_file="perl-5.22.0.tar.bz2"
source_dir="perl-5.22.0"

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

# create /etc/hosts
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
log_auto "/etc/hosts.create" $?

# make perl use the libraries installed on the system
export BUILD_ZLIB=False
export BUILD_BZIP2=0

# configure
log_auto "$package_name.configure.start" 0
sh Configure -des -Dprefix=/usr                 \
   -Dvendorprefix=/usr           \
   -Dman1dir=/usr/share/man/man1 \
   -Dman3dir=/usr/share/man/man3 \
   -Dpager="/usr/bin/less -isR"  \
   -Duseshrplib
log_auto "$package_name.configure.finish" $?

# buld
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
make -k test
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
unset BUILD_ZLIB BUILD_BZIP2
log_auto "$package_name.install.finish" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
