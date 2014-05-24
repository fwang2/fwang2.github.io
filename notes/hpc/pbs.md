# PBS

An old but good reference guide is
[this](http://beige.ucs.indiana.edu/I590/node33.html), a pdf copy is keep on
`Box/HPC`.

## Environment Variables

    PBS_O_HOST - name of the host upon which qsub command is running
    PBS_O_QUEUE - name of the original queue to which the job was submitted
    PBS_O_WORKDIR - absolute path of the current working directory of the qsub command
    PBS_ENVIRONMENT - set to PBS_BATCH to indicate the job is a batch job, or to
    PBS_INTERACTIVE to indicate the job is a PBS interactive job
    PBS_JOBID - the job identifier assigned to the job by the batch system
    PBS_JOBNAME - the job name supplied by the user
    PBS_NODEFILE - the name of the file containing the list of nodes assigned to the job
    PBS_QUEUE - the name of the queue from which the job is executed


You can find out PBS configuration (available queues) by:

## Check configuration

    qstat -q

    server: moab1.ccs.ornl.gov

    Queue            Memory CPU Time Walltime Node  Run Que Lm  State
    ---------------- ------ -------- -------- ----  --- --- --  -----
    debug              --      --    04:00:00   --    3   2 --   E R
    batch              --      --       --      --   28 395 --   E R
    dataxfer           --      --    24:00:00   --    0   0 --   E R
    dtn                --      --       --      --    0   0 --   E R

For example, this tells use the `debug` queue has a walltime limit of 4 hours.


## Hold and release

    qhold [job id]
    qrls [job id]

## Send signals to job

    qsig -s signal [job id]

If your application has a way to respond to signals.


## Interactive jobs

You can obtain interactive console with `-I` option: once you are at the
console, you can do `aprun` without going through pbs.


    alias debug='qsub -I -A stf008 -q debug -l nodes=4,walltime=60:00'


## PBS directives

Here is a list of common PBS directives.


### change output file name

    #PBS -o output_file_name
    #PBS -e err_file_name

### merge output and error

    #PBS -j oe


### change job name

    #PBS -N job_name

### change shell

The submitted script is interpreted using user's login shell by default. PBS
does not read the `#!/bin/bash` line the script usually begin with. But this
can be altered by:

    #PBS -S /bin/bash

### change queue

    #PBS -q debug

### mail options

    #PBS -M fwang2@gmail.com
    #PBS -m abe

* n: no email is sent
* a: sent when job got aborted
* b: sent when job begin execution
* e: sent when job terminates

### export environment variables

    #PBS -V

This directive makes all variables define in the environment from which the
job is submitted available to the job. Wwe can then add more variables by
using the `-v` option followed by variable specification.


Example:

    #PBS -S /bin/bash
    #PBS -V
    LOG=/tmp/work/all.log
    case $STAGE in
    1 )
        /usr/pbs/bin/qsub -v STAGE=2 all.pbs
        ;;
    2 )
        /usr/pbs/bin/qsub -v STAGE=3 all.pbs
        ;;
    3 )
        /usr/pbs/bin/qsub -v STAGE=4 all.pbs
        ;;
    esac >> $LOG 2>&1
    exit 0

The action taken by the script depends on the value of `STAGE`. If `$STAGE` is
1, then we submit another script ...


**Note**: you can pass multiple variable to qsub by:

    qsub -v RSAVE_TIME_LIMIT=30,RSAVE_CHECKFILE=rts.data,RSAVE_RESTART=yes,\
        RSAVE_STEP=$RSAVE_STEP restart.pbs


## Job dependency

The above example show one way to submit job within a job.
The following example show how we set up job dependency.

    !/bin/bash
    FIRST=`qsub first.pbs`
    echo $FIRST
    SECOND=`qsub -W depend=afterok:$FIRST second.pbs`
    echo $SECOND
    THIRD=`qsub -W depend=afterok:$SECOND third.pbs`
    echo $THIRD
    FOURTH=`sub -W depend=afterok:$FIRST:$SECOND fourth.pbs`
    echo $FOURTH
    exit 0

Note that the 4th job depends on both first and second, but not the third job.


