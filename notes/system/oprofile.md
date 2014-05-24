# OProfile


There are two main tools we can use: `perf` (based on Performance Counter for
Linux or PCL) and `oprofile`. Both uses Performance Monitoring Unit (PMU)
hardware, so you can NOT use both at the same time.

## Profiling Lustre

First, [prepare a test Lustre file system](../hpc/lustre_setup.md):

    mount -t lustre /dev/sdc /mdt
    mount -t lustre /dev/sdb /mnt/ost0

Now, we set up control parameters and start the daemon (without start
profiling):


    opcontrol --separate=kernel \
        --vmlinux=/usr/lib/debug/lib/modules/`uname -r`/vmlinux

    opcontrol --callgraph=2
    opcontrol --deinit; modprobe oprofile timer=1; opcontrol --start-daemon


Note that `timer=1` put oprofile into *interrupt* mode, which seems only
necessary for vmware image.


Note that we need to install `kernel-debuginfo-*` from Lustre release site to
have an uncompressed Linux kernel image. oprofile can not deal with the
vmlinuz image.


Lustre client side, we mount:

    mount -t lustre 192.168.92.155:/mytest /lustrefs

Run some I/O benchmark to mounted lustre

    pio -t 3k -o /lustrefs

In between, we will start and stop profiling on server side:

    opcontrol --start
    opcontrol --stop
    opreport -l -p /lib/modules/`uname -r`/kernel /path/to/lustre_binary

`-l` List per-symbol information instead of a binary image summary; `-p` List
comma-separated of additional paths to search for binaries. This is needed to
find modules in kernels 2.6 and upwards.


## Saving profiling data

After you stopped oprofile, you have the option to save the profiling data for
later analysis by:

    opcontrol --save=client_thrash

Then, later, you can check back profile data by:

    opreport session:client_thrash



## Reset for oprofile

1. stop any `perf` command

2. reload oprofile kernel module

        opcontrol --deinit

3. turn off NMI watchdog

        echo 0 > /proc/sys/kernel/nmi_watchdog


## Getting Started

If you want to profile kernel:

    opcontrol --vmlinux=/boot/vmlinux-`uname -r`

Otherwise
    
    opcontrol --no-vmlinux

Next, we can start the daemon (**oprofiled**):

    opcontrol --start

We stop profiling:

    opcontrol --shutdown

The profiling data by default is written into:

    /var/lib/oprofile/samples/


You can control where the data goes by:

    opcontrol --start --session-dir=$HOME/samples


To get a summary of profiling data:

    opreport --session-dir=$HOME/samples

You can clear profile data by:

    opcontrol --reset

## Control the profiling scope


## Reference:

1. /usr/share/doc/oprofile-version/oprofile.html

2. [OProfile Manual](http://oprofile.sourceforge.net/doc/)

3. [Profiling Fedora 6](http://people.redhat.com/~wcohen/FedoraCore6OProfileTutorial.txt)

4. [OProfile Tutorial](http://ssvb.github.io/2011/08/23/yet-another-oprofile-tutorial.html)
