# using     : configuration of non-login shell
#             it must cpy to host:/home/<build-user>/.bashrc
# author    : kevin.leptons@gmail.com

set +h
umask 022
lfs=/mnt/lfs
lc_all=POSIX
lfs_tgt=$(uname -m)-lfs-linux-gnu
LFS=$lfs
LC_ALL=$lc_all
LFS_TGT=$lfs_tgt
PATH=/tools/bin:/bin:/usr/bin
export lfs lc_all lfs_tgt LFS LC_ALL LFS_TGT PATH
