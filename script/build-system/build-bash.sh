#!/bin/bash

# using     : build bash
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
package_name="sys.bash"
source_file="../bash-4.3.30.tar.gz"
patch_file="../../bash-4.3.30-upstream_fixes-2.patch"
source_dir="bash-4.3.30"

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
    patch -Np1 -i $patch_file
}

# step.configure
step_configure() {
    ./configure --prefix=/usr                       \
       --bindir=/bin                       \
       --docdir=/usr/share/doc/bash-4.3.30 \
       --without-bash-malloc               \
       --with-installed-readline
}

# step.build
step_build() {
    make
}

# step.test
step_test() {
    chown -Rv nobody .
    su nobody -s /bin/bash -c "PATH=$PATH make tests"
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
run_step "$package_name.patch" step_patch
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
exit 0
