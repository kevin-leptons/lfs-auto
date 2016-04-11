#!/bin/bash

# using     : build grep
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
package_name="grep"
source_file="grep-2.21.tar.xz"
source_dir="grep-2.21"

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

# fix potential security issue
sed -i -e '/tp++/a  if (ep <= tp) break;' src/kwset.c
log_auto "$package_name.security.fix" $?

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/usr --bindir=/bin
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
make check
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
