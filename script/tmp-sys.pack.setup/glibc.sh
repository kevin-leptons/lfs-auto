#!/bin/bash

# using     : build glibc package
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
package_name="tmp.glibc"
source_file="../glibc-2.22.tar.xz"
source_dir="glibc-2.22"
build_dir="glibc-build"
patch_file="../../glibc-2.22-upstream_i386_fix-1.patch"
simple_program_source="/lfs-script/asset/simple-program.c"
simple_program_dest="/lfs-script/tmp/simple-program"

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

# step.build-dir.mkdir
step_build_dir_mkdir() {
    mkdir -vp $build_dir
}

# step.configure
step_configure() {
    ../$source_dir/configure                             \
          --prefix=/tools                               \
          --host=$LFS_TGT                               \
          --build=$(../$source_dir/scripts/config.guess) \
          --disable-profile                             \
          --enable-kernel=2.6.32                        \
          --enable-obsolete-rpc                         \
          --with-headers=/tools/include                 \
          libc_cv_forced_unwind=yes                     \
          libc_cv_ctors_header=yes                      \
          libc_cv_c_cleanup=yes
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install
}

# step.test
step_test() {
    $LFS_TGT-gcc "$simple_program_source" -o "$simple_program_dest" &&
    readelf -l "$simple_program_dest" | grep '\: /tools' | \
        grep "Requesting program interpreter"
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.patch" step_patch
cd $root_tmp_sources
run_step "$package_name.build-dir.mkdir" step_build_dir_mkdir
cd $build_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_build
run_step "$package_name.install" step_install
run_step "$package_name.test" step_test
rm -vf $simple_program_dest
exit 0
