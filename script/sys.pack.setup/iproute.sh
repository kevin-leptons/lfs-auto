#!/bin/bash

# using     : build iproute
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
package_name="sys.iproute"
source_file="../iproute2-4.2.0.tar.xz"
source_dir="iproute2-4.2.0"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.makefile.edit
step_makefile_edit() {
    sed -i '/^TARGETS/s@arpd@@g' misc/Makefile &&
    sed -i /ARPD/d Makefile &&
    sed -i 's/arpd.8//' man/man8/Makefile
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make DOCDIR=/usr/share/doc/iproute2-4.2.0 install
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.makefile.edit" step_makefile_edit
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
exit 0
