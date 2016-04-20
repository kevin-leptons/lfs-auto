#!/bin/bash

# using     : build eudev
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
package_name="sys.eudev"
source_file="../eudev-3.1.2.tar.gz"
custom_rules_file="../../udev-lfs-20140408.tar.bz2"
source_dir="eudev-3.1.2"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.test.fix
step_test_fix() {
    sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
}

# step./tools.prevent
step_tools_prevent() {
    cat > config.cache << "EOF"
    HAVE_BLKID=1
    BLKID_LIBS="-lblkid"
    BLKID_CFLAGS="-I/tools/include"
    EOF
}

# step.configure
step_configure() {
    ./configure --prefix=/usr           \
       --bindir=/sbin          \
       --sbindir=/sbin         \
       --libdir=/usr/lib       \
       --sysconfdir=/etc       \
       --libexecdir=/lib       \
       --with-rootprefix=      \
       --with-rootlibdir=/lib  \
       --enable-split-usr      \
       --enable-manpages       \
       --enable-hwdb           \
       --disable-introspection \
       --disable-gudev         \
       --disable-static        \
       --config-cache          \
       --disable-gtk-doc-html
}

# step.build
step_build() {
    LIBRARY_PATH=/tools/lib make
}

# step.test-dir.mkdir
step_test_dir_mkdir() {
    mkdir -pv /lib/udev/rules.d &&
    mkdir -pv /etc/udev/rules.d
}

# step.test
step_test() {
    make LD_LIBRARY_PATH=/tools/lib check
}

# step.install
step_install() {
    make LD_LIBRARY_PATH=/tools/lib install
}

# step.custom-rules.install
step_custom_rules_install() {
    tar -xvf $custom_rules_file &&
    make -f udev-lfs-20140408/Makefile.lfs install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.test.fix" step_test_fix
run_step "$package_name./tools/prevent" step_tools_prevent
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test-dir.mkdir" step_test_dir_mkdir
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package_name.custom-rules.install" step_custom_rules_install
exit 0
