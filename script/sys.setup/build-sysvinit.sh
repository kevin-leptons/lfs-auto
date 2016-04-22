#!/bin/bash

# using     : build sysvinit
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="sys.sysvinit"
source_file="../sysvinit-2.88dsf.tar.bz2"
patch_file="../../sysvinit-2.88dsf-consolidated-1.patch"
source_dir="sysvinit-2.88dsf"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.patch
step_patch() {
    patch -Np1 -i $patch_file
}

# step.build
step_build() {
    make -C src
}

# step.install
step_install() {
    make -C src install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.patch" step_patch
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
exit 0
