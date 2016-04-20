#!/bin/bash

# using     : build util-linux
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
package_name="sys.util-linux"
source_file="../util-linux-2.27.tar.xz"
source_dir="util-linux-2.27"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step./var/lib/hwcloc.active
step_var_lib_hwcloc_active() {
    mkdir -pv /var/lib/hwclock
}

# step.configure
step_configure() {
    ./configure ADJTIME_PATH=/var/lib/hwclock/adjtime   \
       --docdir=/usr/share/doc/util-linux-2.27 \
       --disable-chfn-chsh  \
       --disable-login      \
       --disable-nologin    \
       --disable-su         \
       --disable-setpriv    \
       --disable-runuser    \
       --disable-pylibmount \
       --disable-static     \
       --without-python     \
       --without-systemd    \
       --without-systemdsystemunitdir
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    chown -Rv nobody . &&
    su nobody -s /bin/bash -c "PATH=$PATH make -k check"
}

# step.install
step_install() {
    make install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name./var/lib/hwclock.active" step_var_lib_hwcloc_active
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install"
exit 0
