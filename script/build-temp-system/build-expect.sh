#!/bin/bash

# using     : build expect
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd $root_sources

# extract source code and change to source code directory
if [ ! -d expect5.45 ]; then
   tar -xf expect5.45.tar.gz 
fi
cd expect5.45

# fix configure file
cp -v configure{,.orig} &&
sed 's:/usr/local/bin:/bin:' configure.orig > configure &&

# configure
./configure --prefix=/tools       \
   --with-tcl=/tools/lib \
   --with-tclinclude=/tools/include &&

# build
make &&

# test
make test &&

# install
make SCRIPTS="" install
