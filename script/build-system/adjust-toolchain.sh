#!/bin/bash

# using     : adjust the toolchain
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

# define variables
task_name="toolchain"

# backup /tools, replace with linker made in chapter 5
mv -v /tools/bin/{ld,ld-old} &&
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old} &&
mv -v /tools/bin/{ld-new,ld} &&
ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld
log_auto "/tools.backup, replace" $?

# amend gcc
gcc -dumpspecs | sed -e 's@/tools@@g'                   \
   -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
   -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
   `dirname $(gcc --print-libgcc-file-name)`/specs
log_auto "gcc.amend" $?

# ensure that the basic function
echo 'int main(){}' > dummy.c
cc dummy.c -v -Wl,--verbose &> dummy.log &&
log_auto "gcc.compile" $?

# read elf
readelf -l a.out | grep ': /lib' | grep "Requesting program interpreter"
log_auto "readelf" $?

# make sure that we are setup to use the correct startfiles
lib_count=$(grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log | wc)
if [[ $lib_count == 3 ]]; then
    log_auto "/usr/lib/.verify" 0
else
    log_auto "/usr/lib/.verify" 1
fi

# verify that the compiler is searching for the correct header files
grep -B1 '^ /usr/include' dummy.log
log_auto "/usr/include/.verify" $?

# verify the the new linker
grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
log_auto "/usr/lib/.search-dir.verify" $?

# make sure that we are using the correct libc
grep "/lib.*/libc.so.6 " dummy.log
log_auto "/usr/lib/.verify-64bits" $?

# make sure gcc is using the correct dynamic linker
grep found dummy.log
log_auto "gcc.dynamic-link.verify" $?

# clean up the test files
rm -v dummy.c a.out dummy.log

# successfully
log_auto "$task_name.setup.finish" 0
exit 0











