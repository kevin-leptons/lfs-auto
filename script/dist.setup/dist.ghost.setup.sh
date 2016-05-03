#!/bin/bash

# using     : setup direct file system to boot
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="dist.ghost.setup"
syslinux_dest_dir="$dist_direct_fs_boot_mnt/boot"


# step.image.create
step_image_falloc() {
    if [ ! -f  $dist_direct_fs_boot ]; then
        sudo fallocate -l 1.5G $dist_direct_fs_boot
        sudo mkfs.ext4 -F $dist_direct_fs_boot
    fi
}

# step.mount
step_image_mount() {
    if ! mount -l | grep $dist_direct_fs_boot_mnt; then
        sudo mkdir -vp $dist_direct_fs_boot_mnt
        sudo mount $dist_direct_fs_boot $dist_direct_fs_boot_mnt
    fi
}

# step.fs.cp
step_fs_cp() {
    sudo cp -vpru $root/{bin,boot,etc,home,lib,lib64,sbin,usr,var} \
        $dist_direct_fs_boot_mnt
}

# step.syslinux.install
step_syslinux_install() {

    # syslinux.src.extract
    cd "$root/sources/dist-build"
    if [ ! -d "syslinux-6.03" ]; then
        tar -vxf "../syslinux-6.03.tar.gz"
    fi
    cd "../syslinux-6.03"
    mkdir -vp $syslinux_dest_dir

    # syslinux.exec.install
    cp -vpu \
        "bios/core/isolinux.bin" \
        "bios/com32/elflink/ldlinux/ldlinux.c32" \
        "/lfs-script/asset/syslinux.direct/syslinux.cfg"
        $syslinux_dest_dir
    sudo umount $dist_direct_fs_boot_mnt

    # mbr.install
    syslinux --directory /boot/syslinux --install $dist_direct_fs_boot
}

# step.image.umount
step_image_umount() {
    if mount -l | grep $dist_direct_fs_boot_mnt; then
        sudo umount $dist_direct_fs_boot_mnt
    fi
}

# run
run_step "$task_name.image.fallocate" step_image_falloc
run_step "$task_name.image.mount" step_image_mount force
run_step "$task_name.fs.cp" step_fs_cp force
run_step "$task_name.image.umount" step_image_umount force
exit 0
