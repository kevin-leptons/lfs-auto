#!/bin/bash

# using     : active virtual machine with ghost distribution
# params    :
#   $1      : active distribution name
#    - ghost: active with ghost distribution
#    - live: active with live distribution
# author    : kevin.leptons@gmail.com

# bash options
set -e

# variables
vm_type="kvm"
vm_name="lfs.ghost.amd64"
vm_cpus="2"
vm_ram="512"
vm_disk_path="/mnt/lfs/dist/dest/lfs.ghost.amd64.iso"

# handle for exit event
on_exit() {
    echo "stop vm.$vm_name"
    virsh destroy $vm_name
    sudo umount "/mnt/lfs"
}

# shen exit script, kill virtual machine
trap on_exit EXIT

# mount build image
if ! mount -l | grep /mnt/lfs; then
    sudo mount "disk/lfs-disk.img" "/mnt/lfs"
fi

# chown image for bootable
sudo chown $USER:$USER $vm_disk_path

# remove early virtual machine
if virsh list | grep $vm_name; then
    virsh destroy $vm_name
fi
if virsh list --all | grep $vm_name; then
    virsh undefine $vm_name
fi

# vm.install, show on window
# --cdrom $vm_cdrom \
ls /mnt/lfs/dist/dest
virt-install \
    --virt-type $vm_type \
    --name $vm_name \
    --vcpus $vm_cpus \
    --ram $vm_ram \
    --disk $vm_disk_path \
    --boot hd
