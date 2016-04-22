#!/bin/bash

# using     : build perl
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
package_name="sys.perl"
source_file="../perl-5.22.0.tar.bz2"
source_dir="perl-5.22.0"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step./etc/hosts.create
step_etc_hosts_create() {
    echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
}

# step.sys-lib.active
step_sys_lib_active() {
    export BUILD_ZLIB=False
    export BUILD_BZIP2=0
}

# step.configure
step_configure() {
    sh Configure -des -Dprefix=/usr                 \
       -Dvendorprefix=/usr           \
       -Dman1dir=/usr/share/man/man1 \
       -Dman3dir=/usr/share/man/man3 \
       -Dpager="/usr/bin/less -isR"  \
       -Duseshrplib
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make -k test
}

# step.install
step_install() {
    make install
    unset BUILD_ZLIB BUILD_BZIP2
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name./etc/hosts.create" step_etc_hosts_create
run_step "$package_name.sys-lib.active" step_sys_lib_active
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
