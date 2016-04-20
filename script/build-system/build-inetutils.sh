#!/bin/bash

# using     : build inetutils
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
package_name="sys.inetutils"
source_file="../inetutils-1.9.4.tar.xz"
source_dir="inetutils-1.9.4"

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
    ./configure --prefix=/usr        \
       --localstatedir=/var \
       --disable-logger     \
       --disable-whois      \
       --disable-rcp        \
       --disable-rexec      \
       --disable-rlogin     \
       --disable-rsh        \
       --disable-servers
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make check
}

# step.install
step_install() {
    make install
}

# step.exec.mv
step_exec_mv() {
    mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin &&
    mv -v /usr/bin/ifconfig /sbin
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package_name.exec.mv" step_exec_mv
exit 0
