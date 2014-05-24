# Auto share and mount

First, edit `/etc/auto_master`, add the following:

    /Volumes/videos         auto_shares

`auto_master` look into `/etc/auto_shares` and find out what to do when you
access `/Volumes/videos`. So create/edit this file:


    videos -fstype=nfs,resvport,soft,intr,rsize=32768,wsize=32768,\
        noatime,timeo=900,retrans=3,proto=tcp worf.local:/huarong/video

Now, you need to reload:

    automount -vc

