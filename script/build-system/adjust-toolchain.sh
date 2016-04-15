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
simple_program_src="/lfs-script/asset/simple-program.c"
simple_program_dest="/lfs-script/tmp/simple-program"
compile_log_file="/lfs-script/log/compile.log"

# backup /tools, replace with linker made in chapter 5
mv -v /tools/bin/{ld,ld-old} &&
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old} &&
mv -v /tools/bin/{ld-new,ld} &&
if [ -f /tools/bin/ld ]; then
    ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld
fi
log "/tools.backup, replace" $?

# amend gcc
gcc -dumpspecs | sed -e 's@/tools@@g'                   \
   -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
   -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
   `dirname $(gcc --print-libgcc-file-name)`/specs
log "gcc.amend" $?

# ensure that the basic function
cc "$simple_program_src" -o $simple_program_dest \
    -v -Wl,--verbose &> "$compile_log_file" &&
log "gcc.compile" $?

# read elf
readelf -l $simple_program_dest | grep ': /lib' | \
    grep "Requesting program interpreter"
log "readelf" $?

# make sure that we are setup to use the correct startfiles
lib_count=$(grep -o '/usr/lib.*/crt[1in].*succeeded' $compile_log_file | wc -l)
if [[ $lib_count == 3 ]]; then
    log "/usr/lib/.verify" 0
else
    log "/usr/lib/.verify" 1
fi

# verify that the compiler is searching for the correct header files
grep -B1 '^ /usr/include' $compile_log_file
log "/usr/include/.verify" $?

# verify the the new linker
grep 'SEARCH.*/usr/lib' $compile_log_file |sed 's|; |\n|g'
log "/usr/lib/.search-dir.verify" $?

# make sure that we are using the correct libc
grep "/lib.*/libc.so.6 " $compile_log_file
log "/usr/lib/.verify-64bits" $?

# make sure gcc is using the correct dynamic linker
grep found $compile_log_file
log "gcc.dynamic-link.verify" $?

# clean up the test files
rm -v $simple_program_dest $compile_log_file

# successfully
log "$task_name.setup.finish" 0
exit 0
