#!/bin/bash

# using     : build libstdc++ package
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
package_name="tmp.libstdcc++"
source_file="../gcc-5.2.0.tar.bz2"
source_dir="libstdc++"
build_dir="libstdc++-build"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
    mv "gcc-5.2.0" $source_dir
}

# step.build-dir.mkdir
step_build_dir_mkdir() {
    rm -rf $build_dir
    mkdir -vp $build_dir
}

# step.configure
step_configure() {
    ../$source_dir/libstdc++-v3/configure \
        --host=$LFS_TGT                 \
        --prefix=/tools                 \
        --disable-multilib              \
        --disable-nls                   \
        --disable-libstdcxx-threads     \
        --disable-libstdcxx-pch         \
        --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/5.2.0
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
cd $build_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
exit 0
