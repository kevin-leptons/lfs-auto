#!/bin/bash

# using     : build kmod
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
package_name="sys.kmod"
source_file="kmod-21.tar.xz"
source_dir="kmod-21"

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
    ./configure --prefix=/usr          \
       --bindir=/bin          \
       --sysconfdir=/etc      \
       --with-rootlibdir=/lib \
       --with-xz              \
       --with-zlib
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
    for target in depmod insmod lsmod modinfo modprobe rmmod; do
       ln -sv ../bin/kmod /sbin/$target
    done
    ln -sv kmod /bin/lsmod
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.link" step_link
exit 0
