# R Programing

R is pretty easy to get it started. Basic stuffs are:

- Control structure
- Scoping rules
- Environment setup
- Function
- OO programming


## Control structures

- `if,else`

        if (condition) {
            # do something
        } else if (condition) {
            # something else
        } else {
            # something else
        }

- `for`

        x <- c('a','b','c')
        for (i in seq_along(x)) {
            print(i)        # 1, 2, 3
        }

- `while`

        while (z >=3 && z <= 10) {
            ...
        }

- `repeat`: infinite loop until you invoke `break`

- `break`: break the execution of a loop

- `next`: skip an iteration of a loop

- `return`: exit a function

## Functions

Functions in R are called **first class objects**, which means:

- Functions can be passed as arguments to other functions
- Functions can be nested, so you can define a function inside another
  function. The return value of a function is the last expression in the
  function body to be evaluated 

        f <- function(x, y = 1, z = NULL) {
            ...
        }

- **Named arguments** You can give default value by naming argument.

- Argument matching: You can mix positional matching with matching by names.
  Function argument can also be _partially_ matched.The order of operations
  when given an argument is:
    - check for exact match for a named argument
    - check for partial match
    - check for positional match

- Special argument: `...`: it indicates a variable number of arguments that
  are usually passed on to other functions.

        myplot <- function(x, y, type = "l", ...) {
            plot(x,y, type=type, ...)
        }

  Another use is when the number of arguments can not be known in advance: One
  catch is that: any arguments that appear after `...` on the argument list
  **must** be named explicitly and can not be partially matched.

        > args(paste)
        function(..., sep = " ", collapse = NULL)


## Scoping rules

First, R uses the following rules to bind value to a symbol:

- Search the global environment for a symbol name

- Search the namespaces of each of the packages on the search list. The search
  list can be found by using `search` function:

      > search()
      [1] ".GlobalEnv"  "tools:rstudio" "package:graphics" "package:grDevices" "package:utils"    
      [6] "package:datasets"  "package:ggplot2"   "package:stats" "package:methods" "Autoloads" "package:base"     

- The global environment or the user workspace is always the first element
  of the search list.

- When a user loads a package with `library`, the namespace of that package is
  put in position 2 of the search list (by default). Everything else gets
  shifted down the list.

- R has separate namespaces for functions and non-functions. So it is possible
  to have an object named `c` and a function named `c` as well.

**Scoping rules** determines how a value is associated with a free variable in
a function. R uses _lexical scoping_ or _static scoping_. A common alternative is
  _dynamic scoping_.


    f <- function(x,y) {
        x^2 + y/z
    }

The `z` variable is what we call _free_ variable. The scoping rules of a
language determine how values are assigned to free variables. Free variables
are not formal arguments and are not local variables.

The lexical scoping is R means that "the value of the free variables are
searched for in the environment in which the function was defined".

### Environment


- An environment is collection of (symbol, value) pairs.

- Every environment has a parent environment: it is possible for an
  environment to have multiple "children".

- The only environment without a parent is the empty environment

- A function + an environment = _ a closure or function closure_

### Search

- If the value of a symbol is not found in the environment in which a function
was defined, then the search is continued in the _parent environment_.

- The search continues down the sequence of parent environemtn until we hit the
_top level environment, this is usually the global environment (workspace)

- After the top-level environment, the search continues down the search list
  until we hit the _empty environment_. If it still fails, then error out.

### Closure by example

        make.power <- function(n) {
            pow <- function(x) {
                x^n
            }
            pow
        }
        > cube <- make.power(3)
        > square <- make.power(2)
        > cube(3)
        [1] 27
        > square(3)
        [1] 9

What is in a functions environment?

    > ls(environment(cube))
    [1] "n" "pow"
    > get("n", environment(cube))
    [1] 3

### Lexical vs. Dynamic Scoping

    y <- 10
    f <- function(x) {
        y <- 2
        y^2 + g(x)
    }
    
    g <- function(x) {
        x*y
    }

    f(3) = ?

With lexical scoping, the value of `y` in the function `g` is looked up in the
environment in which the function was defined. In this case, the global
environment, so the value of `y` is 10.

With dynamic scoping, the value of `y` is looked up in the environment from
which the function was _called_ (sometimes, it is referred to as the calling
environment), so the value of `y` would be 2.

One consequence of lexical scoping is that in R, all objects must be stored in
memory.


## Programming Examples

### Take a command line argument

    args = commandArgs(trailingOnly = TRUE)
    print(args)
    options( warn = -1)

Now, `args[1]` is the first argument etc.

### Read csv file, skip comments

    df = read.csv(file, comment.char='#', strip.white=TRUE)


### Generate a sequence of file names

    nodes = c(4, 8, 16)
    for (n in nodes) {
       quartz(type="pdf", file=paste("ratio-", n, ".pdf", sep=''), width=10, height=6)
       theme_set(theme_bw(base_family="Lucida Grande", base_size=18))
       ...
    }
