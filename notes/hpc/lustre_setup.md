
# Lustre on Cent OS 6.4/6.5

Officially, Lustre doesn't support 2.4.2 on Cent OS 6.5 ...
But you can obtain a copy of [old kernel
rpm](http://vault.centos.org/6.4/updates/x86_64/Packages/kernel-2.6.32-358.23.2.el6.x86_64.rpm)
which matches what Lustre 2.4.2 is asking. 

## Disable SELinux

You need to disable SELinux on ALL Lustre nodes (both client and servers).
Edit `/etc/sysconfig/selinux` file:

    SELINUX=disabled

If you don't have this step done, `mkfs.lustre` will likely fail.

## Disable iptables

The default CentOS iptables setting is blocking LNET
from working properly. So you would want to do this for test environment only.

    chkconfig iptables off


## e2fsprogs 

You need to download
[e2fsprogs](http://downloads.whamcloud.com/public/e2fsprogs/latest/el6/RPMS/x86_64/).
The manual suggests that you should always get the latest.


    lu1:fwang2 ~/e2fsprogs$ ls
    e2fsprogs-1.42.7.wc2-7.el6.x86_64.rpm
    libcom_err-devel-1.42.7.wc2-7.el6.x86_64.rpm
    e2fsprogs-devel-1.42.7.wc2-7.el6.x86_64.rpm  
    libss-1.42.7.wc2-7.el6.x86_64.rpm
    e2fsprogs-libs-1.42.7.wc2-7.el6.x86_64.rpm
    libss-devel-1.42.7.wc2-7.el6.x86_64.rpm
    libcom_err-1.42.7.wc2-7.el6.x86_64.rpm
    
    lu1:fwang2 ~/e2fsprogs$ rpm -Uvh *.rpm

## Server install

If you have updated to the latest 6.5, you might have to manually remove a few
incompatible rpm first before you can proceed: in particular, kernel and
kernel-firmware rpm.

Also, I can't seem to get kernel-header rpm from Lustre distribution installed
without reverting back to CentOS 6.4.

    lu1:fwang2 ~/lustre-2.4.2-rpms$ ls
    kernel-2.6.32-358.23.2.el6_lustre.x86_64.rpm
    kernel-firmware-2.6.32-358.23.2.el6_lustre.x86_64.rpm
    lustre-2.4.2-2.6.32_358.23.2.el6_lustre.x86_64.x86_64.rpm
    lustre-ldiskfs-4.1.0-2.6.32_358.23.2.el6_lustre.x86_64.x86_64.rpm
    lustre-modules-2.4.2-2.6.32_358.23.2.el6_lustre.x86_64.x86_64.rpm
    lustre-osd-ldiskfs-2.4.2-2.6.32_358.23.2.el6_lustre.x86_64.x86_64.rpm
    lustre-tests-2.4.2-2.6.32_358.23.2.el6_lustre.x86_64.x86_64.rpm
    perf-2.6.32-358.23.2.el6_lustre.x86_64.rpm
    python-perf-2.6.32-358.23.2.el6_lustre.x86_64.rpm


Assuming that we can proceed:
        
    lu1:fwang2 ~/lustre-2.4.2-rpms$ sudo rpm -Uvh *.rpm
    Preparing...                ########################################### [100%]
       1:lustre-ldiskfs         ########################################### [ 11%]
       2:kernel-firmware        ########################################### [ 22%]
       3:kernel                 ########################################### [ 33%]
       4:lustre-modules         ########################################### [ 44%]
       5:lustre-osd-ldiskfs     ########################################### [ 56%]
       6:lustre                 ########################################### [ 67%]
       7:lustre-tests           ########################################### [ 78%]
       8:python-perf            ########################################### [ 89%]
       9:perf                   ########################################### [100%]

## Setup a file system

Let us assume the following block devices are available on the system.

    /dev/sdb    OST target
    /dev/sdc    MGS/MDT target

### On MDS node: create MDT storage and mount it

    mkfs.lustre --fsname=mytest --mgs --mdt --index=0 /dev/sdc
    mkdir -p /mdt
    mount -t lustre /dev/sdc /mdt

### On OSS node, create new OST storage and mount it

    mkfs.lustre --reformat --fsname=mytest --mgsnode 192.168.92.155 \
        --ost --index=0 /dev/sdb
    mkdir -p /ost0
    mount -t lustre /dev/sdb /ost0

'--reformat' is needed only if the block device has been used for Lustre
partition before; `192.168.92.155` is the IP address of MGS server node.

### On client node, mount the file system

    mkdir -p /lustrefs
    mount -t lustre 192.168.92.155:/mytest /lustrefs

### Verification

On client node, do `dd`, 'df', `lfs` on the newly mounted file system


