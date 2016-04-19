#!/bin/bash

# using     : build binutils package in pass 1
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# location.locate
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="binutils-pass-1"
source_file="binutils-2.25.1.tar.bz2"
source_dir="binutils-2.25.1"
build_dir="binutils-build"

# step.verify
step_verify() {
    [ -f $source_file ]
    return $?
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.build-dir.mkdir
step_create_build_dir() {
    mkdir -vp $build_dir
}

# step.configure
step_configure() {
    ../binutils-2.25.1/configure \
        --prefix=/tools \
        --with-sysroot=$LFS \
        --with-lib-path=/tools/lib \
        --target=$LFS_TGT \
        --disable-nls \
        --disable-werror
}

# step.build
step_make() {
    make
}

# step./lib64.mkdir
step_x64_mkdir() {
    case $(uname -m) in
        x86_64)
            mkdir -vp /tools/lib;
            ln -vsf lib /tools/lib64;;
    esac
}

# step.install
step_install() {
    make install
}

# run
cd $root_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
run_step "$package_name.build-dir.mkdir" step_create_build_dir
cd $build_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_make
run_step "$package_name./lib64.mkdir" step_x64_mkdir
run_step "$package_name.install" step_install
exit 0
