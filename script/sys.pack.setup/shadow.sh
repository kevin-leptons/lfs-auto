#!/bin/bash

# using     : build shadow
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
package_name="sys.shadow"
source_file="../shadow-4.2.1.tar.xz"
source_dir="shadow-4.2.1"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.groups.disable
step_groups_disable() {
    sed -i 's/groups$(EXEEXT) //' src/Makefile.in &&
    find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
}

# step.login.defs.sed
step_login_defs_sed() {
    sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' \
       -e 's/PASS_ALWAYS_WARN.*yes$/PASS_ALWAYS_WARN no/' \
       -e 's/PASS_MIN_LEN.*5$/PASS_MIN_LEN 3/' \
       -e 's/LOGIN_RETRIES.*5$/LOGIN_RETRIES 1/' \
       -e 's/PASS_CHANGE_TRIES.*5/PASS_CHANGE_TRIES 1/' \
       etc/login.defs
}

# step.etc/useradd.add
step_etc_useradd_add() {
    sed -i 's/1000/999/' etc/useradd
}

# step.configure
step_configure() {
    ./configure --sysconfdir=/etc --with-group-name-max-length=32
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install
}

# step./usr/bin/passwd.mv
step_passwd_mv() {
    mv -v /usr/bin/passwd /bin
}

# step.shadow.password.enable
step_shadow_pass_enable() {
    pwconv
}

# step.shadow.group-password.enable
step_shadow_pass_group_enable() {
    grpconv
}

# root.pass.change
step_root_pass_change() {
    echo 'root:root' | chpasswd
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.groups.disable" step_groups_disable
run_step "$package_name.login.defs.sed" step_login_defs_sed
run_step "$package_name.etc.useradd.add" step_etc_useradd_add
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.passwd.mv" step_passwd_mv
run_step "$package_name.shadow.pass.enable" step_shadow_pass_enable
run_step "$package_name.shadow.pass-group.enable" step_shadow_pass_group_enable
run_step "$package_name.root.pass.change" step_root_pass_change

exit 0
