#!/bin/bash

# using     : build gzip
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
package_name="sys.gzip"
source_file="../gzip-1.6.tar.xz"
source_dir="gzip-1.6"

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
    ./configure --prefix=/usr --bindir=/bin
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
    mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin &&
    mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin
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
