#!/bin/bash

# using     : build dejagnu
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
package_name="tmp.dejagnu"
source_file="../dejagnu-1.5.3.tar.gz"
source_dir="dejagnu-1.5.3"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.configure
step_configure() {
    ./configure --prefix=/tools
}

# step.install
step_install() {
    make install
}

# test
step_test() {
    make check
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.install" step_install
run_step "$package_name.test" step_test
exit 0
