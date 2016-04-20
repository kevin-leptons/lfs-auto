#!/bin/bash

# using     : build mpfr
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
package_name="sys.mpfr"
source_file="../mpfr-3.1.3.tar.xz"
patch_file="../../mpfr-3.1.3-upstream_fixes-1.patch"
source_dir="mpfr-3.1.3"

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
    ./configure --prefix=/usr        \
       --disable-static     \
       --enable-thread-safe \
       --docdir=/usr/share/doc/mpfr-3.1.3
}

# step.build
step_build() {
    make &&
    make html
}

# step.test
step_test() {
    make check
}

# step.install
step_install() {
    make install &&
    make install-html
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
