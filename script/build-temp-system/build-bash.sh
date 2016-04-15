#!/bin/bash

# using     : build bash
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
package_name="bash"
source_file="bash-4.3.30.tar.gz"
source_dir="bash-4.3.30"

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

# configure
log "$package_name.configure.start" 0
./configure --prefix=/tools --without-bash-malloc
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
make tests
log "$package_name.test.finish" $?

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

# link
ln -sv bash /tools/bin/s
log "$package_name.link" $?

# successfull
log "$package_name.setup.finish" $?
exit 0
