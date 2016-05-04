# linux from scratch automated build
- automated build linux from scratch in docker environemnt
- allow developer can test imediately linux distribution in virtual machine
- new style of linux distribution

# requirements

- linux from scratch version 7.8
- docker version 1.10.3
- docker image debian:jessie
- operating system: debian
- disk space ~32GB

# news

- 2016-05-04: active ghost distribution

# general architecture

    |----------------------------------------------------------------------|
    | linux from scratch                                                   |
    |----------------------------------------------------------------------|
    | docker container                                                     |
    |----------------------------------------------------------------------|
    | host operating system                                                |
    |----------------------------------------------------------------------|

    - host operating system: provide environment to run docker and virtual
      storage, where store linux from scratch

    - docker container: provide environment to build linux from scratch. it is
      use to reduce damage and unnecessary tools to host operating system

    - linux from scratch: contains instructions to build linux from scratch,
      write in shell script

  # documenation

  see [doc directory](./doc)

# instructions

- run automated setup with ghost distribution

```shell
# setup
./run.sh --dist=ghost

# try in virtual machine
./vm.active ghost
```

- enter box environment under dev user

```shell
./run.sh box
```

- enter tmp-sys environment under root user

```shell
./run.sh tmp-sys
```

- enter sys environment under root user

```shell
./run.sh sys
```
