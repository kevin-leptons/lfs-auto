#!/bin/bash

# using     : build readline
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
package_name="sys.readline"
source_file="../readline-6.3.tar.gz"
source_dir="readline-6.3"

# step.verify
step_verify() {
    [ -f $source_file ]
}
run_step "$package_name.verify"

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.patch
step_patch() {
    patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch
}

# step.issuing.avoid
step_issuing_avoid() {
    sed -i '/MV.*old/d' Makefile.in &&
    sed -i '/{OLDSUFF}/c:' support/shlib-install
}

# configure
step_configure() {
    ./configure --prefix=/usr    \
       --disable-static \
       --docdir=/usr/share/doc/readline-6.3
}

# step.build
step_build() {
    make SHLIB_LIBS=-lncurses
}

# step.install
step_install() {
    make SHLIB_LIBS=-lncurses install
}

# step.link
step_link() {
    mv -v /usr/lib/lib{readline,history}.so.* /lib &&
    ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) \
        /usr/lib/libreadline.so &&
    ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
}

# step.doc.install
step_doc_install() {
    install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3
}

# run
cd $root_system_sources
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.patch" step_patch
run_step "$package_name.issuing.avoid" step_issuing_avoid
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
run_step "$package_name.link" step_link
run_step "$package_name.doc.install" step_doc_install
exit 0
