#!/bin/bash

# using     : install linux api header
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
package_name="linux"
source_file="linux-4.2.tar.xz"
source_dir="linux-4.2"

# step.verify
step_verify() {
    [ -f $source_file ];
    return $?
}

# step.extract
step_extract() {
    tar -vxf $source_file
    cd $source_dir
}

# step.mrproper
step_mrproper() {
    make mrproper
}

# step.install
step_install() {
    make INSTALL_HDR_PATH=dest headers_install &&
    cp -rv dest/include/* /tools/include
}

# run
cd $root_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
run_step "$package_name.mrproper" step_mrproper
run_step "$package_name.install" step_install
exit 0
