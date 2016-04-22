#!/bin/bash

# using     : build bc
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
package_name="sys.bc"
source_file="../bc-1.06.95.tar.bz2"
patch_file="../../bc-1.06.95-memory_leak-1.patch"
source_dir="bc-1.06.95"

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

# step.configure
step_configure() {
    ./configure --prefix=/usr           \
       --with-readline         \
       --mandir=/usr/share/man \
       --infodir=/usr/share/info
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    echo "quit" | ./bc/bc -l Test/checklib.b
}

# step.install
step_install() {
    make install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.patch" step_patch
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
