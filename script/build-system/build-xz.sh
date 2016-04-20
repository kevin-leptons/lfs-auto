#!/bin/bash

# using     : build xz
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
package_name="sys.xz"
source_file=../"xz-5.2.1.tar.xz"
source_dir="xz-5.2.1"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.configure
step_configure() {
    ./configure --prefix=/usr    \
       --disable-static \
       --docdir=/usr/share/doc/xz-5.2.1
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make check
}

# step.install
step_install() {
    make install &&
    mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin &&
    mv -v /usr/lib/liblzma.so.* /lib &&
    ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_mpc_name.install" step_install
exit 0
