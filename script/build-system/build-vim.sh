#!/bin/bash

# using     : build vim
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d vim74 ]; then
   tar -xf vim-7.4.tar.bz2
fi
cd vim74

# change default location of vimrc
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h

# configure
./configure --prefix=/usr &&

# build
make &&

# test
make -j1 test

# install
make install &&

# link
ln -sv vim /usr/bin/vi
for L in  /usr/share/man/{,*/}man1/vim.1; do
   ln -sv vim.1 $(dirname $L)/vi.1
done

# link document
ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4

# create /etc/vimrc
cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
   set background=dark
   endif

" End /etc/vimrc
EOF
