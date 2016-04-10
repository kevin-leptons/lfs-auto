#!/bin/bash

# using     : build kernel
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d linux-4.2 ]; then
   tar -xf linux-4.2.tar.xz
fi
cd linux-4.2

# prepre
make mrproper &&
make defconfig &&

# build
make &&

# install
make modules_install &&

# copy kernel
cp -v arch/x86/boot/bzImage /boot/vmlinuz-4.2-lfs-7.8 &&

# copy configuration of kernel
cp -v .config /boot/config-4.2 &&

# install documents
install -d /usr/share/doc/linux-4.2 &&
cp -r Documentation/* /usr/share/doc/linux-4.2 &&

# configure linux module load oder
install -v -m755 -d /etc/modprobe.d &&
cat > /etc/modprobe.d/usb.conf << "EOF"
# Begin /etc/modprobe.d/usb.conf

install ohci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i ohci_hcd ; true
install uhci_hcd /sbin/modprobe ehci_hcd ; /sbin/modprobe -i uhci_hcd ; true

# End /etc/modprobe.d/usb.conf
EOF
