# VMware Fusion on Mac

A few tips and tricks on using VMWare Fusion (5.x)

## Using static IP

This is useful in setting up Lustre, where keep IP static is important.


1. Obtain HW address

    HWaddr 00:0C:29:FA:C1:4F

2. Edit `/Library/Preferences/VMware Fusion/vmnet8/dhcpd.conf`, After the end
of DO NOT MODIFY, add the following:

        host lu1 {
            hardware ethernet 00:0C:29:FA:C1:4F
            fixed-address 192.168.92.155
        }

        host lu2 {
            hardware ethernet 00:0C:29:A4:36:1C
            fixed-address 192.168.92.154
        }
3. Restart network service (or restart Fusion)

        sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --configure
        sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --stop
        sudo /Applications/VMware\ Fusion.app/Contents/Library/vmnet-cli --start


## Fix UID Mapping


One anoyance of having shared folder is the uid and gid mismatch

    sudo umount /mnt/hgfs
    sudo vi /etc/fstab

    .host:/                 /mnt/hgfs       vmhgfs
    defaults,ttl=5,uid=500,gid=500 0 0

uid/gid 500 is fwang2 on my vm host.

Once this is done, sudo mount /mnt/hgfs

That will fix the mapping issue.



