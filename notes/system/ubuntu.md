# Ubuntu System Notes


## Enable networking

    # edit /etc/network/interfaces
    auto eth0
    iface eth0 inet dhcp

    # ifup eth0

## No passwd for sudo

    fwang2  ALL=(ALL) NOPASSWD: ALL

## Install new fonts

    mkdir .fonts
    fc-cache -f -v

## Install XFCE desktop

    sudo apt-get install xubuntu-desktop

## Disable SELinux

    sudo vi /etc/selinux/config
    SELINUX=disabled
