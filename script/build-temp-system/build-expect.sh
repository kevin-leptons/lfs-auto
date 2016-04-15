#!/bin/bash

# using     : build expect
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

# variables
package_name="expect"
source_file="expect5.45.tar.gz"
source_dir="expect5.45"

# log start setup
log "$package_name.setup.start" 0

# change working directory to sources directory
cd $root_sources

# verify
if [ -f $source_file ]; then
    log "$package_name.verify" 0
else
    log "$package_name.verify" $?
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

# configure.fix
cp -v configure{,.orig} &&
sed 's:/usr/local/bin:/bin:' configure.orig > configure
log "$package_name.fix configure file" $?

# configure
log "$package_name.configure.start" 0
./configure --prefix=/tools       \
   --with-tcl=/tools/lib \
   --with-tclinclude=/tools/include
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
make test
log "$package_name.test.finish" $?

# install
log "$package_name.install.start" 0
make SCRIPTS="" install
log "$package_name.install.finish" $?

# successfull
log "$package_name.setup.finish" $?
exit 0
