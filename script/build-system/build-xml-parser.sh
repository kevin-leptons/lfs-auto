#!/bin/bash

# using     : build xml-parser
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# change working directory to sources directory
cd /sources &&

# extract source code and change to source directory
if [ ! -d XML-Parser-2.44 ]; then
   tar -xf XML-Parser-2.44.tar.gz
fi
cd XML-Parser-2.44

# prepare
perl Makefile.PL &&

# build
make &&

# test
make test &&

# install
make install
