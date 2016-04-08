from debian:jessie
maintainer kevin leptons <kevin.leptons@gmail.com>
label Version="1.0" \
      Description="automated build linux from scrapt"
run apt-get update
run apt-get install -y \
   vim \
   sudo \
   bash \
   binutils \
   bison \
   bzip2 \
   coreutils \
   diffutils \
   findutils \
   gawk \
   gcc \
   g++ \
   grep \
   gzip \
   m4 \
   make \
   patch \
   perl \
   sed \
   tar \
   texinfo \
   xz-utils \
   wget \
   gettext \
   build-essential

# make sure that docker meet requirements of lfs
run ln -sf bash /bin/sh
run ln -sf gawk /usr/bin/awk
run ln -sf bison /usr/bin/yacc

# add lfs user to sudores
run echo "lfs ALL=(ALL:ALL) ALL" >> /etc/sudoers

# use vimrc to edit in docker
copy vimrc /root/.vimrc

#workdir /lfs-script
entrypoint /lfs-script/entry-lfs.sh
