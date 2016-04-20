#!/bin/bash

# using     : build coreutils
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
package_name="sys.coreutils"
source_file="../coreutils-8.24.tar.xz"
source_dir="coreutils-8.24"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.patch
step_patch() {
    patch -Np1 -i ../coreutils-8.24-i18n-1.patch &&
    sed -i '/tests\/misc\/sort.pl/ d' Makefile.in
}

# step.configure
step_configure() {
    FORCE_UNSAFE_CONFIGURE=1 ./configure \
       --prefix=/usr            \
       --enable-no-install-program=kill,uptime
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    make NON_ROOT_USERNAME=nobody check-root
}

# step./etc/group.edit
step_etc_group_nobody_edit() {
    echo "dummy:x:1000:nobody" >> /etc/group
}

# step.wd.chown
step_wd_chown() {
    chown -Rv nobody .
}

# step.test
step_test() {
    su nobody -s /bin/bash \
       -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
}

# step./etc/group.dummy.edit
step_etc_group_dummy_edit() {
    sed -i '/dummy/d' /etc/group
}

# step.install
step_install() {
    make install
}

# step.exec.mv
step_exec_mv() {
    mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin &&
    mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin &&
    mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin &&
    mv -v /usr/bin/chroot /usr/sbin &&
    mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8 &&
    sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8 &&
    mv -v /usr/bin/{head,sleep,nice,test,[} /bin
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
dd $source_dir
run_step "$package_name.patch" step_patch
run_step "$package_name.configure" step_configure
run_step "$package_name.make" step_build
run_step "$package_name.test" step_test
run_step "$package_name./etc/group.nobody.edit" step_etc_group_nobody_edit
run_step "$package_name.wd.chown" step_wd_chown
run_step "$package_name.test" step_test
run_step "$package_name./etc/group.dummy.edit" step_etc_group_dummy_edit
run_step "$package_name.install" step_install
run_step "$package_name.exec.mv" step_exec_mv
exit 0
