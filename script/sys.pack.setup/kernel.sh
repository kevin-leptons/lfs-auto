#!/bin/bash

# using     : build kernel
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
package_name="sys.kernel"
source_file="../linux-4.2.tar.xz"
source_dir="linux-4.2"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# prepare
step_prepare() {
    make mrproper
    make defconfig
}

# build
step_build() {
    make
}

# install
step_install() {
    make modules_install
}

# kernel.cp
step_kernel_cp() {
    cp -v arch/x86/boot/bzImage /boot/vmlinuz-4.2-lfs-7.8
}

# kernel.configuration.cp
step_kernel_config_cp() {
    cp -v .config /boot/config-4.2
}

# doc.install
step_doc_install() {
    install -d /usr/share/doc/linux-4.2
    cp -r Documentation/* /usr/share/doc/linux-4.2
}

# module.load-order
step_module_load_order() {
    install -v -m755 -d /etc/modprobe.d
    cp -vp /lfs-script/asset/etc.modprobe.d.usb.conf /etc/modprobe.d/usb.conf
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.prepare" step_prepare
run_step "$package_name.make" step_build
run_step "$package_name.install" step_install
run_step "$package_name.kernel.cp" step_kernel_cp
run_step "$package_name.kernel.config.cp" step_kernel_config_cp
run_step "$package_name.doc.install" step_doc_install
run_step "$package_name.module.config" step_module_load_order
exit 0
