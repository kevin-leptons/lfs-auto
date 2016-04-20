#!/bin/bash

# using     : build grub
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
package_name="step.grub"
source_file="../grub-2.02~beta2.tar.xz"
source_dir="grub-2.02~beta2"

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
       --sbindir=/sbin        \
       --sysconfdir=/etc      \
       --disable-grub-emu-usb \
       --disable-efiemu       \
       --disable-werror
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
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
exit 0
