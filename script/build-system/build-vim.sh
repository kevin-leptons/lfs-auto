#!/bin/bash

# using     : build vim
# params    : none
# return    : 0 on success, 1 on error
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
# use util
source $script_dir/configuration.sh
source $script_dir/util.sh

# variables
package_name="vim"
source_file="vim-7.4.tar.bz2"
source_dir="vim74"

# log start
log_auto "$package_name.setup.start" 0

# change working directory to sources directory
cd /sources

# verify
if [ -f $source_file ]; then
    log_auto "$package_name.verify" 0
else
    log_auto "$package_name.verify" 1
fi

# extract source code and change to source directory
if [ -d $source_dir ]; then
    log_auto "$package_name.extract.idle" 0
else
    log_auto "$package_name.extract.start" 0
    tar -vxf $source_file
    log_auto "$package_name.extract.finish" $?
fi
cd $source_dir

# change default location of vimrc
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
log_auto "/etc/vimrc.use-default" $?

# configure
log_auto "$package_name.configure.start" 0
./configure --prefix=/usr
log_auto "$package_name.configure.finish" $?

# build
log_auto "$package_name.make.start" 0
make
log_auto "$package_name.make.finish" $?

# test
log_auto "$package_name.test.start" 0
make -j1 test
log_auto "$package_name.test.finish" $?

# install
log_auto "$package_name.install.start" 0
make install
log_auto "$package_name.install.finish" $?

# link
ln -sv vim /usr/bin/vi &&
for L in  /usr/share/man/{,*/}man1/vim.1; do
   ln -sv vim.1 $(dirname $L)/vi.1
done
log_auto "$package_name.link" $?

# link document
ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4
log_auto "$package_name.dic.link" $?

# create /etc/vimrc
cp /lfs-script/asset/vimrc /etc/vimrc
log_auto "/etc/vimrc.create" $?

# successfully
log_auto "$package_name.setup.finish" $?
exit 0
