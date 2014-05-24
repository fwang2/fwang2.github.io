# Debugging with pdb/ipdb


[Python 2 PDB Doc](http://docs.python.org/2/library/pdb.html)

## start script in debug mode

    $ ipython
    % run -d test.py

## set breakpoint

    Right after the code that you want to set 

    import ipdb as pdb; pdb.set_trace()

## Commands

    l [first [,last]]   
            list 11 lines around current line, or first and last
            if so specified.

    c   continue, until next break point

    w   where, print a stack trace

    b   [filename:lineno|function[,condition]]
        

        if used without argument, it will list ALL breakpoints

        if condition is provided, the breakpoint is honored only if the
        expression is true.

    cl(ear) [bpnumber [bpnumber...]]

        if used without argument, it will clear ALL breakpoints

        Otherwise, you can clear space-separated breakpoints.

    s   step, execute the current line, step into a function if so.

    n   next, execute past a function if so.

    r   continue execution until current function returns

    a   print argument list of current function

    p   expression

        evaluate the expression in the current context

    run [arg ...]

        restart the debugged Python program

