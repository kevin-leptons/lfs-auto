#!/bin/bash

# using     : wrap all build system task
# author    : kevin.leptons@bmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="sys.pack.setup"
build_sysem_dir="sys.pack.setup"

# start
log "$task_name.start" 0

# hash-flag.off
set +h

# list all script to build package in system
# each script not contains extension
packages=( \
    linux-api-headers \
    man-pages \
    glibc \
    toolchain \
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

# successfully
log "$task_name.finish" $?
exit 0
