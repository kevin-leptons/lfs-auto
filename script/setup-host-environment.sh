#!/bin/bash

# using     : setup host environment
# notes     : tools version will print in format <required:current>
# author    : kevin.leptons@gmail.com

# locate location of this script
__dir__="$(dirname "$0")"

# use configuration
# use util
source $__dir__/configuration.sh
source $__dir__/util.sh

# ?
export LC_ALL=C

# define variables
task_name="verify-host-env"
verify_ok=true
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

# verify bash version
bash_version=$(bash --version | head -n1 | cut -d" " -f4 | cut -d"(" -f1)
if version_gt $bash_version $bash_version_req; then
    log "bash.version.verify.ok" 0
else
    verify_ok=false
    log "bash.version.verify.no" 0
fi

# verify /bin/sh link
sh_link=$(readlink -f /bin/sh)
if [[ $sh_link == $sh_link_req ]]; then
    log "sh.link.verify.ok" 0
else
    log "sh.link.verify.no" 0
fi

# verify binutils
binutils_version=$(ld --version | head -n1 | cut -d" " -f7-)
if version_gt $binutils_version $binutils_version_req; then
    log "binutils.version.verify.ok" 0
else
    verify_ok=false
    log "binutils.version.verify.no" 0
fi

# verify bison
bison_version=$(bison --version | head -n1 | cut -d" " -f4)
if version_gt $bison_version $bison_version_req; then
    log "bison.version.verify.ok" 0
else
    verify_ok=false
    log "bison.version.verify.no" 0
fi

# verify yacc link to bison
# or yacc is executable
if [ -h /usr/bin/yacc ]; then
    yacc_link=$(readlink -f /usr/bin/yacc)
    if [[ $yacc_link == $yacc_link_req ]]; then
        log "yacc.link.verify.ok" 0
    else
        verify_ok=false
        log "yacc.link.verify.no" 0
    fi
elif [ -x /usr/bin/yacc ]; then
    log "yacc.executable.verify.ok" 0
else
    verify_ok=false
    log "yacc.verify.no" 0
fi

# verify bzip2
bzip2_version=$(bzip2 --version 2>&1 < /dev/null | \
    head -n1 | cut -d" " -f8 | cut -d "," -f1)
if version_gt $bzip2_version $bzip2_version_req; then
    log "bzip2.version.verify.ok" 0
else
    verify_ok=false
    log "bzip2.version.verify.no" 0
fi

# verify coreutils
coreutils_version=$(chown --version | head -n1 | cut -d" " -f4)
if version_gt $coreutils_version $coreutils_version_req; then
    log "coreutils.version.verify.ok" 0
else
    verify_ok=false
    log "coreutils.version.verify.no" 0
fi

# verify diffutils
diffutils_version=$(diff --version | head -n1 | cut -d" " -f4)
if version_gt $diffutils_version $diffutils_version_req; then
    log "diffutils.version.verify.ok" 0
else
    verify_ok=false
    "diffutils.version.verify.no" 0
fi

# verify findutils
findutils_version=$(find --version | head -n1 | cut -d" " -f4)
if version_gt $findutils_version $findutils_version_req; then
    log "findutils.version.verify.ok" 0
else
    verify_ok=false
    log "findutils.version.verify.no" 0
fi

# verify gawk
gawk_version=$(gawk --version | head -n1 | cut -d" " -f3 | cut -d"," -f1)
if version_gt $gawk_version $gawk_version_req; then
    log "gawk.version.verify.ok" 0
else
    verify_ok=false
    log "gawk.version.verify.no" 0
fi

# verify awk link to gawk
if [ -h /usr/bin/awk ]; then
    awk_link=$(readlink -f /usr/bin/awk)
    if [[ $awk_link == $awk_link_req ]]; then
        log "awk.link.verify.ok" 0
    else
        verify_ok=false
        log "awk.link.verify.no" 0
    fi
elif [ -x /usr/bin/awk ]; then
    log "awk.executable.verify.ok" 0
else
    verify_ok=false
    log "awk.verify.no" 0
fi

# verify gcc
gcc_version=$(gcc --version | head -n1 | cut -d" " -f4)
if version_gt $gcc_version $gcc_version_req; then
    log "gcc.version.verify.ok" 0
else
    verify_ok=false
    log "gcc.version.verify.no" 0
fi

# verify g++
gpp_version=$(g++ --version | head -n1 | cut -d" " -f4)
if version_gt $gpp_version $gcc_version_req; then
    log "g++.version.verify.ok" 0
else
    verify_ok=false
    log "g++.version.verify.no" 0
fi

# verify glibc
glibc_version=$(ldd --version | head -n1 | cut -d" " -f5)
if version_gt $glibc_version $glibc_version_req; then
    log "glibc.version.verify.ok" 0
else
    verify_ok=false
    log "glibc.version.verify.no" 0
fi

# verify grep
grep_version=$(grep --version | head -n1 | cut -d" " -f4)
if version_gt $grep_version $grep_version_req; then
    log "grep.version.verify.ok" 0
else
    verify_ok=false
    log "grep.version.verify.ok" 0
fi

# verify gzip
gzip_version=$(gzip --version | head -n1 | cut -d" " -f2)
if version_gt $gzip_version $gzip_version_req; then
    log "gzip.version.verify.ok" 0
else
    verify_ok=false
    log "gzip.version.verify.no" 0
fi

# verify linux kernel
linux_version=$(cat /proc/version | cut -d" " -f3 | cut -d"-" -f1)
if version_gt $linux_version $linux_version_req; then
    log "linux.version.verify.ok" 0
else
    verify_ok=false
    log "linux.version.verify.no" 0
fi

# verify m4
m4_version=$(m4 --version | head -n1 | cut -d" " -f4)
if version_gt $m4_version $m4_version_req; then
    log "m4.version.verify.ok" 0
else
    verify_ok=false
    log "m4.version.verify.no" 0
fi

# verify make
make_version=$(make --version | head -n1 | cut -d" " -f3)
if version_gt $make_version $make_version_req; then
    log "make.version.verify.ok" 0
else
    verify_ok=false
    log "make.version.verify.no" 0
fi

# verify patch
patch_version=$(patch --version | head -n1 | cut -d" " -f3)
if version_gt $patch_version $patch_version_req; then
    log "patch.version.verify.ok" 0
else
    verify_ok=false
    log "patch.version.verif.no" 0
fi

# verify perl
perl_version=$(perl -V:version | cut -d"'" -f2)
if version_gt $perl_version $perl_version_req; then
    log "perl.version.verify.ok" 0
else
    verify_ok=false
    log "perl.version.verify.no" false
fi

# verify sed
sed_version=$(sed --version | head -n1 | cut -d" " -f4)
if version_gt $sed_version $sed_version_req; then
    log "sed.version.verify.ok" 0
else
    verify_ok=false
    log "sed.version.verify.no" 0
fi

# verify tar
tar_version=$(tar --version | head -n1 | cut -d" " -f4)
if version_gt $tar_version $tar_version_req; then
    log "tar.version.verify.ok" 0
else
    verify_ok=false
    log "tar.version.verify.no" 0
fi

# verify texinfo
texinfo_version=$(makeinfo --version | head -n1 | cut -d" " -f4)
if version_gt $texinfo_version $texinfo_version_req; then
    log "texinfo.version.verify.ok" 0
else
    verify_ok=false
    log "texinfo.version.verify.no" 0
fi

# verify xz
xz_version=$(xz --version | head -n1 | cut -d" " -f4)
if version_gt $xz_version $xz_version_req; then
    log "xz.version.verif.ok" 0
else
    verify_ok=false
    log "xz.version.verify.no" 0
fi

# try compiler g++
program_path="tmp/simple-program"
g++ -o $program_path asset/simple-program.c
if [ -x $program_path ]; then
    log "g++.compile.verify.ok" 0
else
    verify_ok=false
    log "g++.compile.verify.no" 0
fi

# verify library
# include: gmp, mpfr, mpc
lib_found=0
for lib in lib{gmp,mpfr,mpc}.la; do
    if find /usr/lib* -name $lib | grep -q $lib; then
        lib_found=$(($lib_found + 1))
    fi
done
if [[ $lib_found == 0 || $lib_found == 3 ]]; then
    log "{gmp, mpfr, mpc}.verify.ok" 0
else
    log "{gmp, mpfr, mpc}.verify.no" 0
fi
unset lib

# finish verify tools
if [[ $verify_ok == true ]]; then
    log "$task_name.finish" 0
    exit 0
else
    log "$task_name.finish" 1
    exit 1
fi
