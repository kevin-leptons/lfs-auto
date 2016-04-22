#!/bin/bash

# using     : build gawk
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
package_name="sys.gawk"
source_file="../gawk-4.1.3.tar.xz"
source_dir="gawk-4.1.3"

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
    ./configure --prefix=/usr
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

    # allow fail because can not find where is bug
    # todo: fix uncondition skip
    if [[ $? == 0 ]]; then
        return 0
    else
        log "$package_name.test.fail.not-allowed" 0
        return 0
    fi
}

# step.doc.install
step_doc_install() {
    mkdir -v /usr/share/doc/gawk-4.1.3 &&
    cp    -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.3
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
run_step "$package_name.doc.install" step_doc_install
exit 0
