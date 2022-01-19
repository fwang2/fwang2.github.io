---
layout: post
title: Configure a Single Host Lustre development environment 
categories:
- Lustre
---


This note is a short summary of setting up Lustre on a single VM, purely for experimental and development purpose. The working environment is a Mac + Fusion + Redhat 7.

## Prep work

we want to remove the two rpms that interferes with Lustre-provide rpms. Also, we import EPEL repo as well.

    $ sudo yum remove kernel-tools kernel-tools-libs
    $ sudo yum install epel-release


We need to disable SELinux on ALL Lustre nodes (both client and servers). Edit 
`/etc/sysconfig/selinux file`:

    SELINUX=disabled

## Prep block storage

We needs a couple of block devices: each of the following devices are equally sized as 50 GB.


    /dev/sdb    mdt
    /dev/sdc    ost1
    /dev/sdd    ost2
    /dev/sde    ost3

## Enable ZFS Repo and Install

The following steps are from (zfs wiki)[https://github.com/zfsonlinux/zfs/wiki/RHEL-%26-CentOS]. We can just follow the kABI-tracking kmod method.

    $ sudo yum install \
        http://download.zfsonlinux.org/epel/zfs-release.el7_3.noarch.rpm

    $ gpg --quiet --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux


Following the instruction and switch to `zfs-mod`:

    # /etc/yum.repos.d/zfs.repo
    [zfs]
    -enabled=1
    +enabled=0
    [zfs-kmod]
    -enabled=0
    +enabled=1

Now, we can use yum to install zfs

    $ sudo yum install zfs

## Lustre Repo and Install

This Repo only works for CentOS 7:

    # /etc/yum.repos.d/lustre.repo
    [lustre-server]
    name=CentOS-$releasever - Lustre
    baseurl=https://downloads.hpdd.intel.com/public/lustre/latest-feature-release/el7/server/
    gpgcheck=0

    [e2fsprogs]
    name=CentOS-$releasever - Ldiskfs
    baseurl=https://downloads.hpdd.intel.com/public/e2fsprogs/latest/el7/
    gpgcheck=0

    [lustre-client]
    name=CentOS-$releasever - Lustre
    baseurl=https://downloads.hpdd.intel.com/public/lustre/latest-feature-release/el7/client/
    gpgcheck=0


## On all nodes (MDS/OSS/Client)

    $ sudo yum upgrade e2fsprogs
    $ sudo yum install lustre-tests

## Configure Networks

* On all nodes (Optional as far as this dev node is concerned), create the following file:

    ```
    # /etc/modprobe.d/lnet.conf
    options lnet networks=tcp0(eth1)
    ```

* On MDS/OSS only, create the following files to auto-load the module on boot:

    ```
    #!/bin/sh
    # file: /etc/sysconfig/modules/lnet.modules
    if [ ! -c /dev/lnet ]; then
        exec /sbin/modprobe lnet >/dev/null 2>&1
    fi
    ```


If we do everything right, then Lustre should be installed. **Reboot** now.


## Create MDT storage on MDS node

create MDT storage and mount it:

    mkfs.lustre --fsname=mytest --mgs --mdt --index=0 /dev/sdb
    mkdir -p /mnt/mdt
    mount -t lustre /dev/sdb /mnt/mdt



## Create OST storage on OSS node

create new OST storage and mount it

    mkfs.lustre --reformat --fsname=mytest --mgsnode 172.16.139.208 --ost --index=0 /dev/sdc
    mkdir -p /mnt/ost0
    mount -t lustre /dev/sdc /mnt/ost0


`--reformat` is needed only if the block device has been used for Lustre partition before; `172.16.139.208` is the IP address of MGS server node. Lustre requires a non-loopback address, so `localhost` can not be used as a shortcut.


## On Client node

At this point, we can load the lustre kernel module by:

    modprobe lustre

We can (optionally) create the following file to load it on boot:

    ```
    #!/bin/sh
    # /file: etc/sysconfig/modules/lustre.modules
    if [ ! $? ]; then
        /sbin/modprobe lustre >/dev/null 2>&1
    fi
    ```

On client node(s), create the mount point and mount the file system:

    mkdir -p /lustrefs
    mount -t lustre 172.16.139.208:/mytest /lustrefs


## Verification
 
On client node, do dd, 'df', lfs on the newly mounted file system 

And to restore the system after reboot, we might have to:

    mount -t lustre /dev/sdb /mnt/mdt
    mount -t lustre /dev/sdc /mnt/ost0
    mount -t lustre /dev/sdd /mnt/ost1
    mount -t lustre /dev/sde /mnt/ost2
    mount -t lustre 192.168.92.155:/mytest /lustrefs 
 






