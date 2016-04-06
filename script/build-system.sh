#!/bin/bash

# using     : wrap all build system task
# author    : kevin.leptons@bmail.com

# locate location of this script
__dir__="$(dirname "$0")"
build_sysem_dir=$__dir__/build-system

# require root permision
$__dir__/require-root.sh

# use configuration
source $__dir__/configuration.sh

# clear log file
> $log_build_file

# list all script to build package in system
# each script not contains extension
packages=( \
    install-linux-api-headers \
    build-man-pages \
    build-glibc \
    adjust-toolchain \
    build-zlib \
    build-file \
    build-binutils \
    build-gmp \
    build-mpfr \
    build-mpc \
    build-gcc \
    build-bzip2 \
    build-pkg-config \
    build-ncurses \
    build-attr \
    build-acl \
    build-libcap \
    build-sed \
    build-shadow \
    build-psmisc \
    build-procps-ng \
    build-e2fsprogs \
    build-coreutils \
    build-iana-etc \
    build-m4 \
    build-flex \
    build-bison \
    build-grep \
    build-readline \
    build-bash \
    build-bc \
    build-libtool \
    build-gdbm \
    build-expat \
    build-inetutils \
    build-perl \
    build-xml-parser \
    build-autoconf \
    build-automake \
    build-diffutils \
    build-gawk \
    build-fildutils \
    build-gettext \
    build-intltool \
    build-gperf \
    build-groff \
    build-xz \
    build-grub \
    build-less \
    build-gzip \
    build-iproute \
    build-kbd \
    build-kmod \
    build-libpipeline \
    build-make \
    build-patch \
    build-sysklogd \
    build-sysvinit \
    build-tar \
    build-texinfo \
    build-eudev \
    build-util-linux \
    build-man-db \
    build-vim \
    clean \
    build-lfs-bootscripts \
    config-network \
    config-systemv \
    config-profile \
    config-inputrc \
    config-shell \
    config-file-system \
    build-kernel \
    config-grub \
    create-status-build \
)

# build each package
for package in ${packages[@]}; do
    $build_sysem_dir/$package.sh
done
