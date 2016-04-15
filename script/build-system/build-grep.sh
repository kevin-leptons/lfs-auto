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
log "$package_name.setup.start" 0

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log "$package_name.verify" 0
else
    log "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log "$package_name.extract.idle" 0
else
    log "$package_name.extract.start" 0
    tar -vxf $source_file
    log "$package_name.extract.finish" $?
fi
cd $source_dir

# fix potential security issue
sed -i -e '/tp++/a  if (ep <= tp) break;' src/kwset.c
log "$package_name.security.fix" $?

# configure
log "$package_name.configure.start" 0
./configure --prefix=/usr --bindir=/bin
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
# allow copyright test fail
# todo: fix wrong verify test fail allowed
log "$package_name.test.start" 0
make check
if [[ $? == 0 ]]; then
    log "$package_name.test.finish" $?
else

    test_log_file="gnulib-tests/test-suite.log"
    if grep -w "FAIL test-update-copyright.sh" "$test_log_file"; then
        log "$package_name.test.fail.allowed" 0
        log "$package_name.test.finish" 0
    else
        log "$package_name.test.fail.allowed" 1
        log "$package_name.test.finish" 1
    fi
fi

# install
log "$package_name.install.start" 0
make install
log "$package_name.install.finish" $?

# successfully
log "$package_name.setup.finish" $?
exit 0
