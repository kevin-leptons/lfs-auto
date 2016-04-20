#!/bin/bash

# using     : adjust the toolchain
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
task_name="sys.toolchain"
simple_program_src="/lfs-script/asset/simple-program.c"
simple_program_dest="/lfs-script/tmp/simple-program"
compile_log_file="/lfs-script/log/compile.log"

# step./tools.backup
step_tool_backup() {
    mv -v /tools/bin/{ld,ld-old} &&
    mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old} &&
    mv -v /tools/bin/{ld-new,ld} &&
    if [ -f /tools/bin/ld ]; then
        ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld
    fi
}

# step.gcc.amend
step_gcc_amend() {
    gcc -dumpspecs | sed -e 's@/tools@@g'                   \
       -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' \
       -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' >      \
       `dirname $(gcc --print-libgcc-file-name)`/specs
}

# step.gcc.compile
step_gcc_compile( {
    cc "$simple_program_src" -o $simple_program_dest \
        -v -Wl,--verbose &> "$compile_log_file" &&
    readelf -l $simple_program_dest | grep ': /lib' | \
        grep "Requesting program interpreter"
}

# step./usr/lib/.verify
step_usr_lib_verify() {
    lib_count=$(grep -o '/usr/lib.*/crt[1in].*succeeded' $compile_log_file \
        | wc -l)
    if [[ $lib_count == 3 ]]; then
        return 0
    else
        return 1
    fi
}

# step./usr/include/.verify
step_usr_include_verify() {
    grep -B1 '^ /usr/include' $compile_log_file
}

# step.linker.verify
step_linker_verify() {
    grep 'SEARCH.*/usr/lib' $compile_log_file |sed 's|; |\n|g'
}

# step./libc.verify
step_libc_verify() {
    grep "/lib.*/libc.so.6 " $compile_log_file
}

# step.dynamic-linker.verify
step_dynamic_linker() {
    grep found $compile_log_file
}

# run
run_step "$task_name./tools.backup" step_tool_backup
run_step "$task_name.gcc.amend" step_gcc_amend
run_step "$task_name.gcc.compile" step_gcc_compile
run_step "$task_name./usr/lib/.verify" step_usr_lib_verify
run_step "$task_name./usr/include/.verify" step_usr_include_verify
run_step "$task_name.linker.verify"
run_step "$task_name.libc.verify" step_libc_verify
run_step "$task_name.dynamic-linker.verify" step_dynamic_linker
rm -v $simple_program_dest $compile_log_file
exit 0
