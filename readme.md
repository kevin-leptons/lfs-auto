# new linux distribution
this is new gnu/linux system focus on two side
- developer: make developing become easily
- end-user: make work become easily

**notes**

- for first version v1.0, check [lfs branch](https://github.com/kevin-leptons/lfs-auto/tree/lfs)
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

# specification
from simple equation of physical: **s = v.t**
- s: lenght of road which object move
- v: speed of object
- t: time which object moving

now, use that equation with other meaning
- s: value is created by developing system or develop tools for system
- v: speed of developing
- t: time span which developing has occur

specify v by two other quantity: **v = h/c**
- v: speed of developing
- h: work ability of human, it is same as intelligence quotient
- c: complexity of work

target of this gnu/linux distribution is reduce complexity of archiecture and
source code of system. that is mean
- c_sys: complexity of this system
- c_osys: complexity of other system
- c_sys < c_osys

prove that in the same time, value is created by this gnu/linux system is more
than other system above
- **s_sys > s_osys**
- s_sys: value is created by this system
- s_osys: value is created by other system

prove that time switch between system of this system less than other system
- **time_sswitch < time_osswitch**
- time_sswitch: time uses to switch between this system
- time_osswitch: time uses to switch between other system

# prove

**s_sys > s_osys**
- v_sys = h/c_sys: speed of developing of system
- v_osys = h/c_osys: speed of developingof other system
- c_sys < c_osys, reference to specification section
- v_sys > v_osys
- s_sys = v_sys.t
- s_osys = v_osys.t
- s_sys > s_osys (proved)

**time_sswitch < time_osswitch**
- time_sswitch = 0, because you can do real work, learning on this system
- time_osswitch > 0, because you must chose compartive system with your work
- time_sswitch < time_osswitch (proved)

# conclusions
- **s_sys > s_osys** mean that value has created by this system more than other
  system. that value will split into feature as fast-develop, stable, leanrning
- fedora have same as target - make developing more quickly, but it is only
  target. they are not descrease complexity of system low enough to make system
  stable
- debian, ubuntu, centos have same as target - make system stable ,
  but it is too complex, so they spend more time to develop
- **time_sswitch < time_osswitch** safe your time

# benefit

- fast-learning
- fast-developing
- safe time
- updated
- stable system

# mailing list
- kevin.leptons@gmail.com
