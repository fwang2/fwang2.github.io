# R Programming, Take 3

This section is about debugging and profiling.

R has message, warning, error (fatal), or conditions.

## traceback()

It prints out the function call stack after an error occurs. 

    > lm(z~x)
    Error in eval(expr, envir, enclos) : object 'z' not found
    > traceback()
    7: eval(expr, envir, enclos)
    6: eval(predvars, data, env)
    5: model.frame.default(formula = z ~ x, drop.unused.levels = TRUE)
    4: stats::model.frame(formula = z ~ x, drop.unused.levels = TRUE)
    3: eval(expr, envir, enclos)
    2: eval(mf, parent.frame())
    1: lm(z ~ x)

## debug()

It flags a function for "debug" mode, which allows you to step through
execution of a function one line at a time.

    >debug(lm)
    >lm(z~x)

Then you will be in browser mode, `n` will step you through the function

## str()

One of the most useful function in R: it can compactly display internal
structure of an R object.

    > str(lm)
    > f <- gl(40,10)
    > str(f)

    > library(datasets)
    > str(airquality)

## Simulation

### Random number generation

- d for density
- r for random number generation
- p for cumulative distribution
- q for quantile function

    > str(dnorm)

    >set.seed(1)
    >rnorm(5)
    >set.seed(1)
    >rnorm(5)

