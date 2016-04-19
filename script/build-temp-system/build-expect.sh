#!/bin/bash

# using     : build expect
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="expect"
source_file="../expect5.45.tar.gz"
source_dir="expect5.45"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# configure.fix
step_configure_fix() {
    cp -v configure{,.orig} &&
    sed 's:/usr/local/bin:/bin:' configure.orig > configure
}

# configure
step_configure() {
    ./configure --prefix=/tools       \
       --with-tcl=/tools/lib \
       --with-tclinclude=/tools/include
}


# build
step_build() {
    make
}

# test
step_test() {
    make test
}

# install
step_install() {
    make SCRIPTS="" install
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure.fix" step_configure_fix
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
