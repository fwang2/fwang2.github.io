# ZFS Setup

A quick and dirty run down on setting up ZFS on a home server, identified here
as `worf.local`. You can use IP address if you don not have zeroconf/avahi
setup on the local network. Note that the raidz2 choose as well as partition
scheme are all random and fake here, they are not following ZFS best practice
in any shape or form (for example, raidz1 if 3, 5, 7 ...; raidz2 if 4, 6, 8
...; use physical disk of same sizes etc etc.)

on Ubuntu:

    sudo -i
    add-apt-repository  --yes ppa:zfs-native/stable
    apt-get update
    apt-get debootstrap ubuntu-zfs

check zfs status:

    modprobe zfs
    dmesg | grep ZFS

[This page](http://zfsonlinux.org/epel.html) has Redhat/CentOS instructions.

## partition

I have one 2TB drive and one 1.5TB drive.
So, 

    partd /dev/sda 
    mklabel msdos
    mkpart primary 1 500GB
    mkpart primary 500GB 1000GB
    mkpart primary 1000GB 1500GB
    mkpart primary 1500GB 2000GB

I now have `/dev/sda{1..4}` and `/dev/sdc{1..3}`.

## set it up

    zpool create huarong raidz2 sda1 sda2 sda3 sda4 sdc1 sdc2 sdc3
    zfs create huarong/videos
    zfs set compression=lzjb huarong/videos
    zfs list

## export and share it

    zfs set sharenfs="rw=@10.0.1.0/24" huarong/videos
    zfs share huarong/videos
    showmount -e worf.local

## client mount (Mac OS)

    mount -t nfs -o resvport worf.local:/huarong/videos /Volumes/videos

Other possible tweaking on client mount:

     mount -t nfs \ 
        -o soft,intr,rsize=8192,wsize=8192,timeo=900,retrans=3,proto=tcp,resvport \
        worf.local:/huarong/videos /Volume/videos



Note `-o resvport` is must, otherwise, you will see error message of operation
not permitted.

