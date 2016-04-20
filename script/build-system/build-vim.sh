#!/bin/bash

# using     : build vim
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
package_name="sys.vim"
source_file="../vim-7.4.tar.bz2"
source_dir="vim74"

# step.verify
step_verify() {
    [ -f $source_file ]
}

# step.extract
step_extract() {
    tar -vxf $source_file
}

# step.default-vimrc.change
step_default_vimrc_change() {
    echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
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
    make -j1 test
}

# step.install
step_install() {
    make install
}

# step.link
step_link() {
    ln -sv vim /usr/bin/vi &&
    for L in  /usr/share/man/{,*/}man1/vim.1; do
       ln -sv vim.1 $(dirname $L)/vi.1
    done
}

# step.doc.link
step_doc_link() {
    ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4
}

# step./etc/vimrc.cp
step_etc_vimrc_cp() {
    cp /lfs-script/asset/vimrc /etc/vimrc
}

# run
cd $root_system_sources
run_step "$package_name.verify" step_verify
run_step "$package_name.extract" step_extract
cd $source_dir
run_step "$package_name.default-vimrc.change" step_default_vimrc_change
run_step "$package_name.configure" step_configure
run_step "$package_name.build" step_build
run_step "$package_name.test" step_test
run_step "$package_name.install" step_install
run_step "$package_name.link" step_link
run_step "$package_name.doc.link" step_doc_link
run_step "$package_name./et/vimrc.cp" step_etc_vimrc_cp
exit 0
