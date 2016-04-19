#!/bin/bash

# using     : build bzip2
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
package_name="bzip2"
source_file="../bzip2-1.0.6.tar.gz"
source_dir="bzip2-1.0.6"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make PREFIX=/tools install
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.make" step_build
run_step "$package_name.install" step_install
exit 0
