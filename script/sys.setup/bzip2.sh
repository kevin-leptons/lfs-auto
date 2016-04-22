#!/bin/bash

# using     : build bzip2
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
package_name="sys.bzip2"
source_file="../bzip2-1.0.6.tar.gz"
patch_file="../../bzip2-1.0.6-install_docs-1.patch"
source_dir="bzip2-1.0.6"

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
    patch -Np1 -i $patch_file &&
    sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile &&
    sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
}

# step.prepare
step_prepare() {
    make -f Makefile-libbz2_so &&
    make clean
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make PREFIX=/usr install
}

# step.shared-lib.install
step_shared_lib_install() {
    cp -v bzip2-shared /bin/bzip2 &&
    cp -av libbz2.so* /lib &&
    ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so &&
    rm -v /usr/bin/{bunzip2,bzcat,bzip2} &&
    ln -sv bzip2 /bin/bunzip2 &&
    ln -sv bzip2 /bin/bzcat
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.patch" step_patch
run_step "$package_name.prepare" step_prepare
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.shared-lib.install" step_shared_lib_install
exit 0
