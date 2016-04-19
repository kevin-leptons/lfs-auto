#!/bin/bash

# using     : build binutils pacage in pass 2
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
package_name="binutils-pass-2"
source_file="../binutils-2.25.1.tar.bz2"
source_dir="binutils-pass-2"
build_dir="binutils-pass-2-build"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
    mv "binutils-2.25.1" $source_dir
}

# step.build-dir.mkdir
step_build_dir_mkdir() {
    rm -rf $build_dir
    mkdir -vp $build_dir
}

# step.configure
step_configure() {
    CC=$LFS_TGT-gcc                \
    AR=$LFS_TGT-ar                 \
    RANLIB=$LFS_TGT-ranlib         \
    ../$source_dir/configure     \
        --prefix=/tools            \
        --disable-nls              \
        --disable-werror           \
        --with-lib-path=/tools/lib \
        --with-sysroot
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install
}

# step.link
step_link() {
    make -C ld clean &&
    make -C ld LIB_PATH=/usr/lib:/lib &&
    cp -v ld/ld-new /tools/bin
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
cd $build_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_build
run_step "$package_name.install" step_install
run_step "$package_name.link" step_link
exit 0
