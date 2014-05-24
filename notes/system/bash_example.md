# Annoated Bash Shell Example

fwang2@gmail.com


The example script is a PBS job script used to submit to Cray supercomputer for I/O benchmarking. As so, it might be only useful to a niche audience :-)



## Check if a variable is set, if not, assign it to a different value.


	[[ "PBS_JOBID"]] || PBS_JOBID=$(date +%s)
	

## Read from a file line by line

Each line has a number of fields separeted by white spaces.


	exec 3 < myfile
	while read -u 3 var1 var2 var3 var4; do
		...
	done
	exec 3>&-
		

The first line link file descriptor 3 with file `myfile`.

Similiarly, 

	exec < myfile.in
	
means stdin is replaced by file `myfile.in` and

	exec > myfile.out


redirects `stdout` to a designated file, in this case, the `myfile.out`.

See [this page](http://tldp.org/LDP/abs/html/x17891.html) for more information



## I/O Redirection: Closing File Descriptors

	exec 3>&-
	
Close output file descriptor 3.

	exec 3<&-
	
Close input file descriptor 3.


So in the above snippet for reading from a file, it seems that we should close input file descriptor 3. For some reason I don't yet know, it is closing output file descriptor instead.


Read [I/O Redirection](http://www.tldp.org/LDP/abs/html/io-redirection.html) for more information.



## Read only a certain number of lines


	NCOUNT=1008
	while read -u 3 rank nid ost rtr; do
		[[ $rank -ge $NCOUNT ]] && break;
		…
	done
	

Obviously, we assumed the field `rank` is a sequence of number from 1, 2, 3, … 



## Aprun: specify node list by -L


To build a list of NID that can supply as a command line option to Aprun's -L, we can:

	wnodes=
	rnodes=
	while read -u 3 rank nid ost lnet rtr cost rnid ignore; do
		…
		wnodes=${wnodes},$nid
		rnodes=${rnodes},$rnid
	done
	
As we build up the node list, we will end up with a list such as `wnodes=",3,5,6,7,8"`. To remove the first character, we use substring extraction: ${string:position}, where we extract substring from $string at $position.
	
	wnodes=${wnodes:1}For more complete string manipulation, see [this page](http://tldp.org/LDP/abs/html/string-manipulation.html)Once we obtained the NID list, we can lanuch aprun job as:
	aprun -n $NCOUNT -N 1 -L $wnodes ${IOR} …
		



					






 
