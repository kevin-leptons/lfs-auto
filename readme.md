# new linux distribution
this is new gnu/linux system focus on two side
- developer: make developing become easily
- end-user: make work become easily

**warning**

- for first version v1.0, check [lfs](https://github.com/kevin-leptons/lfs-auto/tree/lfs) branch
- target of lfs branch are different than master branch now
- this project must be rename (finding new name)

# motivation
each existing gnu/linux system have one advantage/disadvantage of them
- debian, centos: stable/slow-develop
- rhel: supported/fee, slow-develop
- ubuntu: stable/fat system
- fedora: updated/non-stable
- arch: optimized, learning/hard-to-use
- lfs: learning/non-real-uses

depend on your work, you must moving on new system and pay by time
- real product: debian, centos, rhel, ubuntu
- learning: fedora, arch, lfs

this target of gnu/linux system are get advantages of other gnu/linux
system. this system will help developer stop pay for learning by time
and end-user have an better system
- fast-develop: fedora
- stable: debian, centos, rhel, ubuntu
- learning: lfs, fedora
- optimized: arch

**warning**: this is not an conflict with unix philosophy and will explain in
below section
- do one thing and do it well
- worse is better

# specification (researching)
costs as money, human, hardware and time can be convert to cost of time
- time_learn: time span use to learn new system
- time_dev: time span use to develop system
- time_dev_on: time span use to develop other tools on new system
- time: total of time uses
- systems: set of system, sample systems = (debian, fedora, arch)
- sys-i: system i-th
- time_*(sys-i): time uses for sys-i

system developer side

    # multi system
    time_msys = T(1-n)(time_learn(sys-i) + time_dev(sys-i))

    # this system
    time_sys = time_learn(sys) + time_dev(sys)

    # to prove
    time_sys < time_msys

tools developer side

    # multi system
    time_mtools = T(1-n)(time_learn(sys-i) + time_dev_on(sys-i))

    # this system
    time_tools = time_learn(sys) + time_dev_on(sys)

    # to prove
    time_tools < time_mtools

# prove (researching)

# mailing list
- kevin.leptons@gmail.com
