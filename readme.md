# linux from scratch automated build
automated build linux from scratch in docker environemnt. continue update
document

# news

setup system has successful by run script ./run.sh. more work to do
re construct project because it was become complicated

# documenation

see [doc directory](./doc)

# specifications

   - linux from scratch version 7.8
   - docker version 1.10.3
   - docker image debian:jessie

# requirements

    - operating system: unix, gnu/linux (only debian now)
    - disk space about 32GB

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

# instructions

## run automated setup
```shell
./run.sh
```

## enter box environment under dev user
```shell
./run.sh box
```

## enter tmp-sys environment under root user
```shell
./run.sh tmp-sys
```

## enter sys environment under root user
```shell
./run.sh sys
```
