


## Slurm


    sudo yum install mariadb-server mariadb-devel -y



## Create global user

Two groups and users are created:


    export MUNGEUSER=1991
    groupadd -g $MUNGEUSER munge
    useradd  -m -c "MUNGE Uid 'N' Gid Emporium" -d /var/lib/munge -u $MUNGEUSER \
        -g munge    -s /sbin/nologin munge

    export SLURMUSER=1992
    groupadd -g $SLURMUSER slurm
    useradd  -m -c "SLURM workload manager" -d /var/lib/slurm -u $SLURMUSER \
        -g slurm  -s /bin/bash slurm

## Install and configure munge

Assume EPEL repo is in place:

    yum install munge munge-libs munge-devel -y


After installing munge, create a secret key on the server node:


    yum install rng-tools -y
    rngd -r /dev/urandom


    dd if=/dev/urandom bs=1 count=1024 > /etc/munge/munge.key
    chown munge: /etc/munge/munge.key
    chmod 400 /etc/munge/munge.key


After secret key is created, you need to send this key to all of the compute nodes:


    scp /etc/munge/munge.key root@dev2:/etc/munge
    ...

Now, we SSH into every node and correct the permissions as well as start the Munge service.

    chown -R munge: /etc/munge/ /var/log/munge/
    chmod 0700 /etc/munge/ /var/log/munge/


    systemctl enable munge
    systemctl start munge


To test Munge, we can try to access another node with Munge from our server node, dev1


    munge -n
    munge -n | unmunge
    munge -n | ssh 3.buhpc.com unmunge
    remunge


If you encounter no errors, then Munge is working as expected.




### Slurm deps.

    yum install openssl openssl-devel pam-devel numactl numactl-devel hwloc hwloc-devel lua lua-devel readline-devel rrdtool-devel ncurses-devel man2html libibmad libibumad -y


download slurm

     wget http://www.schedmd.com/download/latest/slurm-17.02.6.tar.bz2




    yum install rpm-build
    rpmbuild -ta slurm-15.08.9.tar.bz2






