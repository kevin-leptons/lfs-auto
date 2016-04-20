#!/bin/bash

# using     : build acl
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
package_name="sys.acl"
source_file="../acl-2.2.52.src.tar.gz"
source_dir="acl-2.2.52"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.doc.modify
step_doc_modify() {
    sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
}

# step.broken-test.fix
step_broken_test_fix() {
    sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
}

# step.bug.fix
step_bug_fix() {
    sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" \
       libacl/__acl_to_any_text.c
}

# step.configure
step_configure() {
    ./configure --prefix=/usr    \
       --bindir=/bin    \
       --disable-static \
       --libexecdir=/usr/lib
}

# step.build
step_build() {
    make
}

# step.install
step_install() {
    make install install-dev install-lib &&
    chmod -v 755 /usr/lib/libacl.so
}

# step.lib.mv
step_lib_mv() {
    mv -v /usr/lib/libacl.so.* /lib &&
    ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.doc.modify" step_doc_modify
run_step "$package_name.broken-test.fix" step_broken_test_fix
run_step "$package_name" step_bug_fix
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.lib.mv" step_lib_mv
exit 0
