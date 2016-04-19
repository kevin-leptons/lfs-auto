#!/bin/bash

# using     : build gettext
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
package_name="gettext"
source_file="../gettext-0.19.5.1.tar.xz"
source_dir="gettext-0.19.5.1"

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
    EMACS="no" ./configure --prefix=/tools --disable-shared
}

# step.build
step_build() {
    make -C gnulib-lib &&
    make -C intl pluralx.c &&
    make -C src msgfmt &&
    make -C src msgmerge &&
    make -C src xgettext
}

# step.install
step_install() {
    cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
}

# run
cd $root_tmp_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.install" step_install
exit 0
