#!/bin/bash

# using     : build tcl-core
# time      : 0.5 sbu
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
package_name=tcl-core
source_file=tcl-core8.6.4-src.tar.gz
source_dir=tcl8.6.4

# change working directory to sources directory
cd $root_sources

# log start setup
log_build "$package_name.setup.start" true

# vefify
if [ ! -f $source_file ]; then
    log_build "$package_name.verify" false
else
    log_build "$package_name.verify" true
fi

# extract source code and change to source directory
if [ ! -d $source_dir ]; then
   tar -xf $source_file
fi
cd $source_dir

# configure
log_build "$package_name.configure.start" true
cd unix
./configure --prefix=/tools
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
TZ=UTC make test
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

# make library writeable, so can removed later
chmod -v u+x /tools/lib/libtcl8.6.so
if [[ $? != 0 ]]; then
    log_build "$package_name.make library writeable" false
    exit 1
else
    log_build "$package_name.make library writeable" true
fi

# install tcl headers
log_build "$package_name.install tcl headers.start" true
make install-private-headers
if [[ $? != 0 ]]; then
    log_build "$package_name.install tcl headers.finish" false
    exit 1
else
    log_build "$package_name.install tcl headers.finish" true
fi

# link
ln -sv tclsh8.6 /tools/bin/tclsh
if [[ $? != 0 ]]; then
    log_build "$package_name.link.finish" false
    exit 1
else
    log_build "$package_name.link.finish" true
fi

# successfull
log_build "$package_name.setup.finish" true
exit 0
