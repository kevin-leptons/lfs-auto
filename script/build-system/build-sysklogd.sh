#!/bin/bash

# using     : build sysklogd
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
package_name="sys.sysklogd"
source_file="../sysklogd-1.5.1.tar.gz"
source_dir="sysklogd-1.5.1"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.ksym_mod.c.fix
step_ksym_mod_c_fix() {
    sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make BINDIR=/sbin install
}

# step./etc/syslog.conf.cp
step_syslog_conf_cp() {
    cp -vp /lfs-script/asset/syslog.conf /etc/syslog.conf
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.ksym-mod.c.fix" step_ksym_mod_c_fix
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.syslog.conf.cp" step_syslog_conf_cp
exit 0
