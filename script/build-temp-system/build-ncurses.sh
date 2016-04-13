#!/bin/bash

# using     : build ncurses
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
package_name="ncurses"
source_file="ncurses-6.0.tar.gz"
source_dir="ncurses-6.0"

# log start setup
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

# prepare
sed -i s/mawk// configure
log_auto "$package_name.configure.prepare" $?

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/tools \
            --with-shared   \
            --without-debug \
            --without-ada   \
            --enable-widec  \
            --enable-overwrite
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# successfull
log_auto "$package_name.setup.finish" $?
exit 0
