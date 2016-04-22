#!/bin/bash

# using     : clean remove static lib
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# remove static lib
rm /usr/lib/lib{bfd,opcodes}.a
rm /usr/lib/libbz2.a
rm /usr/lib/lib{com_err,e2p,ext2fs,ss}.a
rm /usr/lib/libltdl.a
rm /usr/lib/libz.a
