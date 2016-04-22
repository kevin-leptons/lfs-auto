#!/bin/bash

# using     : wrap all build system task
# author    : kevin.leptons@bmail.com

# locate location of this script
__dir__="$(dirname "$0")"
build_sysem_dir=$__dir__/build-system

# libs
source $__dir__/configuration.sh
source $__dir__/util.sh

# variables
task_name="sys"

# start
log "$task_name.setup.start" 0

# hash-flag.off
set +h

# list all script to build package in system
# each script not contains extension
packages=( \
    linux-api-headers \
    man-pages \
    glibc \
    adjust-toolchain \
    zlib \
    file \
    binutils \
    gmp \
    mpfr \
    mpc \
    gcc \
    bzip2 \
    pkg-config \
    ncurses \
    attr \
    acl \
    libcap \
    sed \
    shadow \
    psmisc \
    procps-ng \
    e2fsprogs \
    coreutils \
    iana-etc \
    m4 \
    flex \
    bison \
    grep \
    readline \
    bash \
    bc \
    libtool \
    gdbm \
    expat \
    inetutils \
    perl \
    xml-parser \
    autoconf \
    automake \
    diffutils \
    gawk \
    findutils \
    gettext \
    intltool \
    gperf \
    groff \
    xz \
    grub \
    less \
    gzip \
    iproute \
    kbd \
    kmod \
    libpipeline \
    make \
    patch \
    sysklogd \
    sysvinit \
    tar \
    texinfo \
    eudev \
    util-linux \
    man-db \
    vim \
    clean \
)

# build each package
# log is generate by internal build script
result=done
for package in ${packages[@]}; do

    # call setup instructions
    $build_sysem_dir/$package.sh

    # log setup result
    exit_on_error
done

# continue process depend on params
case "$1" in

    # transfer control to user unser shell
    "sys" )
        log "sys.root.login" 0
        bash;;

    # continue process immediately
    # todo: implement this
    * ) 
esac

# successfully
log "$task_name.setup.finish" $?
exit 0
