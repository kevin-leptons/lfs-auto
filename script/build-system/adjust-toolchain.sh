#!/bin/bash

# using     : adjust the toolchain
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"
script_dir="$(dirname $__dir__)"

# use configuration
source $script_dir/configuration.sh

# backup /tools, replace with linker made in chapter 5
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

# amend gcc
gcc -dumpspecs | sed -e 's@/tools@@g'                   \
   -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
   -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
   `dirname $(gcc --print-libgcc-file-name)`/specs

# ensure that the basic function
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'

# make sure that we are setup to use the correct startfiles
grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log

# verify that the compiler is searching for the correct header files
grep -B1 '^ /usr/include' dummy.log

# verify the the new linker
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'

# make sure that we are using the correct libc
grep "/lib.*/libc.so.6 " dummy.log

# make sure gcc is using the correct dynamic linker
grep found dummy.log

# clean up the test files
rm -v dummy.c a.out dummy.log













