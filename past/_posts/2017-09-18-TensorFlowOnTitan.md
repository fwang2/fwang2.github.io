---
layout: post
title: Running TensorFlow on Titan Supercomputer
categories:
- Deep Learning
---

OLCF's current Supercomputer Titan is 4 years in production, lots of system software are dated by today's standard. It can be a challenge to run some of the latest deep learning frameworks. This post describes the general steps and show some examples.



# Into interactive mode

Here, I ask Titan for a single node from debug queue (the max number of node you can ask is 4 nodes), for 60 minutes.

    qsub -I -A stf008 -q debug -l nodes=1,walltime=60:00


# Load tensorflow modules

OLCF builts TensorFlow around `Singularity` container, when you load TF, the `singularity` should be also loaded into the path.

    module load tensorflow

# Launch it through aprun

This is important, first you can't just run it from your home directory - as with other Titan apps, you need to switch to Lustre scratch file system; second, the job must be launch using the `aprun`. The tensorflow package is compiled with SSE4.1 - compute node supports it, but login node doesn't. If you just run from login node, it will complain. On top of that, the login node doesn't have GPU anyway - so there is really no point of running from there.

```
fwang2@titan-login2 /lustre/atlas2/stf008/scratch/fwang2$ aprun -n 1 singularity exec $TENSORFLOW_CONTAINER python /lustre/atlas2/stf008/scratch/fwang2/tf.py
2017-10-10 19:01:14.113889: I tensorflow/core/common_runtime/gpu/gpu_device.cc:955] Found device 0 with properties:
name: Tesla K20X
major: 3 minor: 5 memoryClockRate (GHz) 0.732
pciBusID 0000:02:00.0
Total memory: 5.62GiB
Free memory: 5.52GiB
2017-10-10 19:01:14.113945: I tensorflow/core/common_runtime/gpu/gpu_device.cc:976] DMA: 0
2017-10-10 19:01:14.113964: I tensorflow/core/common_runtime/gpu/gpu_device.cc:986] 0:   Y
2017-10-10 19:01:14.113992: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1045] Creating TensorFlow device (/gpu:0) -> (device: 0, name: Tesla K20X, pci bus id: 0000:02:00.0)
2017-10-10 19:01:14.180572: I tensorflow/core/kernels/logging_ops.cc:79] This is a: [1 3]
```












