# CentOS 6

Bunch of useless stuff.

### EPEL 

Checkout [this page](https://fedoraproject.org/wiki/EPEL) for more details.

    wget http://mirror.pnl.gov/epel/6/i386/epel-release-6-8.noarch.rpm
    yum localinstall epel-release-6-8.noarch.rpm
    yum update


### CentOS Software Collection

This item lags far behind RHEL distribution, but it is finally here, thank
God. Unfortunately, RHEL has progressed to 1.1 I think, also the [current
collection](http://wiki.centos.org/AdditionalResources/Repositories/SCL) does
not have newer GCC toolchain.

    yum install centos-release-SCL


### Avahi and zeroconf


We need to install `avahi-daemon`. Also, we need to modify
`/etc/avahi/avahi-daemon.conf` for it work properly.

    [server]
    host-name=worf
    domain-name=local

    [publish]
    publish-addresses=yes
    publish-hinfo=yes
    publish-workstation=yes
    publish-domain=yes

I am not sure if all of these are must, but having them works. 
Also, disable iptables.

### Grant sudo to myself: `visudo`

    fwang2  ALL=(ALL)       NOPASSWD: ALL

### ZFS

Checkout [this page](http://zfsonlinux.org/epel.html) for more details.

    yum localinstall --nogpgcheck \
        http://archive.zfsonlinux.org/epel/zfs-release-1-3.el6.noarch.rpm
    yum install zfs 


