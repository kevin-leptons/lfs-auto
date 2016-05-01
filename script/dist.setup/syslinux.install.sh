#!/bin/bash

# using     : install syslinux
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# run with lfs user
# file system has own by root
# require root premision to run
require_root

# variables
package_name="dist.syslinux"
source_file="../syslinux-6.03.tar.gz"
source_dir="syslinux-6.03"
dest_dir="$dist_build_dir/syslinux"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.lib.install
step_lib_install() {
    mkdir -vp $dest_dir
    cp -vp \
        "bios/core/isolinux.bin" \
        "bios/com32/elflink/ldlinux/ldlinux.c32" \
        "bios/com32/menu/vesamenu.c32" \
        "bios/com32/lib/libcom32.c32" \
        "bios/com32/libutil/libutil.c32" \
        $dest_dir
}

# step.config.install
step_config_install() {
    cp -vpr /lfs-script/asset/syslinux/* $dest_dir
}

# step.kernel.cp
step_kernel_cp() {
    cp -vpr "$root/boot/$kernel_name" $dist_build_dir
}

# run
cd "$root/sources/dist-build"
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.lib.install" step_lib_install
run_step "$package_name.config.install" step_config_install force
run_step "$package_name.kernel.cp" step_kernel_cp
exit 0
