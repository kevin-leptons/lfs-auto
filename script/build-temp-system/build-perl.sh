#!/bin/bash

# using     : build perl
# params    : none
# return    : 0 on successfull, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# libs
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="perl"
source_file="../perl-5.22.0.tar.bz2"
source_dir="perl-5.22.0"

# test.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.configure
step_configure() {
    sh Configure -des -Dprefix=/tools -Dlibs=-lm
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    cp -v perl cpan/podlators/pod2man /tools/bin &&
    mkdir -pv /tools/lib/perl5/5.22.0 &&
    cp -Rv lib/* /tools/lib/perl5/5.22.0
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install"
exit 0
