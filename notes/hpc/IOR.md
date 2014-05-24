# A Short Guide to IOR Benchmarking

fwang2@gmail.com

A brief guide to the most often used IOR options and tips of doing large scale IOR benchmarking.


## Common IOR Options


	-F		file per process

without this option, the default mode will be shared file for all processes.


	-r 		read existing file
	-w		write file
	
	-b		block size (total size per process)
	-t 		transfer size (t < b)
	
	-C		re-order tasks when doing read
	-g		use barriers in between

	-k 		do NOT remove test file on program exit
	
	-e		write sync

we use -e option in all our IOR tests.


	-E		useExistingTestFile, do NOT remove test file before
			write access.
			
This option is often used in combination with pre-creating IOR files. And
often, after we pre-create IOR files, we set striping information to control
data placement.
 	

	-o		full name of testfile

The IOR man page says this option provides testfile full name, but in
actuality, it is really the prefix of the testfile. Thus, if we specify: `-o
${T1DIR}/fpp`, the actual filename is:
	
	fname=$(printf "fpp.%08d" $rank)

Here the rank refers to MPI rank number.




	-v 		verbose level

you can supply one, two, three such option to controll how verbose the output
will be.


## Test Multiple File Systems


			

