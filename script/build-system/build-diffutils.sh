#!/bin/bash

# using     : build diffutils
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
package_name="diffutils"
source_file="diffutils-3.3.tar.xz"
source_dir="diffutils-3.3"

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

# fix a file so locale file are isntalled
sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in
log "$package_name.locale-file.fix" $?

# configure
log "$package_name.configure.start" 0
./configure --prefix=/usr
log "$package_name.configure.finish" $?

# build
log "$package_name.make.start" 0
make
log "$package_name.make.finish" $?

# test
log "$package_name.test.start" 0
make check
if [[ $? == 0 ]]; then
    log "$package_name.test.finish" 0
else

    test_log_file="gnulib-tests/test-suite.log"
    if grep -w "FAIL: test-update-copyright.sh" "$test_log_file"; then
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
