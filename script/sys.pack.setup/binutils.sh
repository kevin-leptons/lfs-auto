#!/bin/bash

# using     : build binutils
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
package_name="sys.binutils"
source_file="../binutils-2.25.1.tar.bz2"
source_dir="binutils-2.25.1"
build_dir="binutils-build"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.ptys.verify
step_ptys_verify() {
    expect -c "spawn ls"
}

# step.build-dir.mkdir
step_build_dir_mkdir() {
    mkdir -vp $build_dir
}

# step.configure
step_configure() {
    ../binutils-2.25.1/configure --prefix=/usr   \
       --enable-shared \
       --disable-werror

}

# step.build
step_build() {
    make tooldir=/usr
}

# step.test
step_test() {
    make check
}

# step.install
step_install() {
    make tooldir=/usr install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
run_step "$package_name.ptys.verify" step_ptys_verify
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
cd $build_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
