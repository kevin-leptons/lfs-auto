#!/bin/bash

# using     : setup temporary system environment
# notes     : tools version will print in format <required:current>
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source configuration.sh
source util.sh

# ?
export LC_ALL=C

# define variables
task_name="box.dev.pack.verify"
bash_version_req="3.2"
sh_link_req="/bin/bash"
binutils_version_req="2.17"
bison_version_req="2.3"
yacc_link_req="/usr/bin/bison"
bzip2_version_req="1.0.4"
coreutils_version_req="6.9"
diffutils_version_req="2.81"
findutils_version_req="4.2.31"
gawk_version_req="4.0.1"
awk_link_req="/usr/bin/gawk"
gcc_version_req="4.1.2"
glibc_version_req="2.11"
grep_version_req="2.5.1a"
gzip_version_req="1.3.12"
linux_version_req="2.6.32"
m4_version_req="1.4.10"
make_version_req="3.81"
patch_version_req="2.5.4"
perl_version_req="5.8.8"
sed_version_req="4.1.5"
tar_version_req="1.22"
texinfo_version_req="4.7"
xz_version_req="5.0.0"

# log start verify
log "$task_name.start" 0

# bash.verify
bash_version=$(bash --version | head -n1 | cut -d" " -f4 | cut -d"(" -f1)
version_gt $bash_version $bash_version_req
log "bash.version.verify" $?

# /bin/sh.verify
sh_link=$(readlink -f /bin/sh)
str_eq $sh_link $sh_link_req
log "sh.link.verify" $?

# binutils.verify
binutils_version=$(ld --version | head -n1 | cut -d" " -f5)
version_gt $binutils_version $binutils_version_req
log "binutils.version.verify" $?

# bison.verify
bison_version=$(bison --version | head -n1 | cut -d" " -f4)
version_gt $bison_version $bison_version_req
log "bison.version.verify" $?

# yacc.verify
if [ -h /usr/bin/yacc ]; then
    yacc_link=$(readlink -f /usr/bin/yacc)
    str_eq $yacc_link $yacc_link_req
    log "yacc.verify" $?
elif [ -x /usr/bin/yacc ]; then
    log "yacc.verify" 0
else
    log "yacc.verify" 1
fi

# bzip2.verify
bzip2_version=$(bzip2 --version 2>&1 < /dev/null | \
    head -n1 | cut -d" " -f8 | cut -d "," -f1)
version_gt $bzip2_version $bzip2_version_req
log "bzip2.version.verify" $?

# coreutils.verify
coreutils_version=$(chown --version | head -n1 | cut -d" " -f4)
version_gt $coreutils_version $coreutils_version_req
log "coreutils.version.verify" $?

# diffutils.verify
diffutils_version=$(diff --version | head -n1 | cut -d" " -f4)
version_gt $diffutils_version $diffutils_version_req
log "diffutils.version.verify" $?

# verify findutils
findutils_version=$(find --version | head -n1 | cut -d" " -f4)
version_gt $findutils_version $findutils_version_req
log "findutils.version.verify" $?

# verify gawk
gawk_version=$(gawk --version | head -n1 | cut -d" " -f3 | cut -d"," -f1)
version_gt $gawk_version $gawk_version_req
log "gawk.version.verify" $?

# awk.verify
if [ -h /usr/bin/awk ]; then
    awk_link=$(readlink -f /usr/bin/awk)
    str_eq $awk_link $awk_link_req
    log "awk.verify" $?
elif [ -x /usr/bin/awk ]; then
    log "awk.verify" 0
else
    log "awk.verify" 1
fi

# gcc.verify
gcc_version=$(gcc --version | head -n1 | cut -d" " -f3)
version_gt $gcc_version $gcc_version_req
log "gcc.version.verify" $?

# g++.verify
gpp_version=$(g++ --version | head -n1 | cut -d" " -f3)
version_gt $gpp_version $gcc_version_req
log "g++.version.verify" $?

# glibc.verify
glibc_version=$(ldd --version | head -n1 | cut -d" " -f4)
version_gt $glibc_version $glibc_version_req;
log "glibc.version.verify" $?

# grep.verify
grep_version=$(grep --version | head -n1 | cut -d" " -f4)
version_gt $grep_version $grep_version_req;
log "grep.version.verify" $?

# gzip.verify
gzip_version=$(gzip --version | head -n1 | cut -d" " -f2)
version_gt $gzip_version $gzip_version_req
log "gzip.version.verify" $?

# linux-kernel.verify
linux_version=$(cat /proc/version | cut -d" " -f3 | cut -d"-" -f1)
version_gt $linux_version $linux_version_req
log "linux.version.verify" $?

# m4.verify
m4_version=$(m4 --version | head -n1 | cut -d" " -f4)
version_gt $m4_version $m4_version_req
log "m4.version.verify" $?

# make.verify
make_version=$(make --version | head -n1 | cut -d" " -f3)
version_gt $make_version $make_version_req
log "make.version.verify" $?

# patch.verify
patch_version=$(patch --version | head -n1 | cut -d" " -f3)
version_gt $patch_version $patch_version_req;
log "patch.version.verify" $?

# perl.verify
perl_version=$(perl -V:version | cut -d"'" -f2)
version_gt $perl_version $perl_version_req
log "perl.version.verify" $?

# sed.verify
sed_version=$(sed --version | head -n1 | cut -d" " -f4)
version_gt $sed_version $sed_version_req
log "sed.version.verify" $?

# tar.verify
tar_version=$(tar --version | head -n1 | cut -d" " -f4)
version_gt $tar_version $tar_version_req
log "tar.version.verify" $?

# texinfo.verify
texinfo_version=$(makeinfo --version | head -n1 | cut -d" " -f4)
version_gt $texinfo_version $texinfo_version_req
log "texinfo.version.verify" $?

# xz.verify
xz_version=$(xz --version | head -n1 | cut -d" " -f4)
version_gt $xz_version $xz_version_req
log "xz.version.verify" $?

# g++.compile.verify
program_path="tmp/simple-program"
g++ -o $program_path asset/simple-program.c
[ -x $program_path ]
log "g++.compile.verify" $?

# gmp, mpfr, mpc}.verify
lib_found=0
for lib in lib{gmp,mpfr,mpc}.la; do
    if find /usr/lib* -name $lib | grep -q $lib; then
        lib_found=$(($lib_found + 1))
    fi
done
unset lib
[[ $lib_found == 0 || $lib_found == 3 ]]
log "{gmp, mpfr, mpc}.verify" 0

# successfull
log "$task_name.finish" 0
exit 0
