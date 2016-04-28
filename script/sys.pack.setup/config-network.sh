#!/bin/bash

# using     : configure network
# author    : kevin.leptons@gmail.com

# libs
source configuration.sh
source util.sh

# variables
task_name="network.configure"

config_network() {
    # create /etc/sysconfig/ifconfig.eth0
    cd /etc/sysconfig/
    cat > ifconfig.eth0 << "EOF"
    ONBOOT=yes
    IFACE=eth0
    SERVICE=ipv4-static
    IP=192.168.1.4
    GATEWAY=192.168.1.1
    PREFIX=24
    BROADCAST=192.168.1.255
    EOF

    # create /etc/resolv.conf
    cat > /etc/resolv.conf << "EOF"
    # Begin /etc/resolv.conf

    #domain <Your Domain Name>
    #nameserver <IP address of your primary nameserver>
    #nameserver <IP address of your secondary nameserver>

    # End /etc/resolv.conf
    EOF

    # set host name
    echo "<lfs>" > /etc/hostname

    # create /etc/hosts
    cat > /etc/hosts << "EOF"
    # Begin /etc/hosts (network card version)

    127.0.0.1 localhost

    # End /etc/hosts (network card version)
    EOF
}

run_step "$task_name" config_network
