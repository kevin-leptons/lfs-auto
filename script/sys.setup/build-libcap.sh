#!/bin/bash

# using     : build libcap
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
package_name="sys.libcap"
source_file="../libcap-2.24.tar.xz"
source_dir="libcap-2.24"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.static-lib.prevent
step_static_lib_prevent() {
    sed -i '/install.*STALIBNAME/d' libcap/Makefile
}

# build
step_build() {
    make
}

# step.install
step_install() {
    make RAISE_SETFCAP=no prefix=/usr install &&
    chmod -v 755 /usr/lib/libcap.so
}

# step.lib.mv
step_lib_mv() {
    mv -v /usr/lib/libcap.so.* /lib &&
    ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.static-lib.prevent" step_static_lib_prevent
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.lib.mv" step_lib_mv
exit 0
