# R Programming: Take II

- Data and Time
- Apply functions (lapply, sapply, apply, tapply, split)


## Data and Time

- Date are presented by `Date` class, internally stored as number of days
  since 1970-01-01.

- Time are represented by `POSIXct`  or `POSIXlt` class, internally stored as
  number of seconds since 1970-01-01.

        > x = as.Date("1970-1-1")
        > unclass(x)
        0
        > x <- Sys.time()
        > p <- as.POSIXlt(x)
        > names(unclass(p))     # POSIXlt is a list
        [1] "sec"   "min"   "hour"  "mday"  "mon"   "year"  "wday"  "yday" "isdst"

- `strptime` function : convert character string to Date class

    y <- strptime("9 Jan 2011 11:34:31", "%d %b %Y %H:%M:%S")


## Loop functions

- R got a bunch: `lappy`, `sapply`, `apply`, `tapply`, `mapply`.

- The workhorse is `lapply`: it loops over a list and evaluate a
  function on each element. `sapply` is a variant of `lapply`, but try to
  simplify the result.

- Another function `split()` is often used in conjunction with `lapply`.

## lapply

It takes three arguments: (1) a list x; (2) a function (or the name of a
function) FUN; (3) other argument via its `...` argument for the function. If
x is not a list, it will be coerced into a list using `as.list()`.

`lapply` will always return a list.

    > x <- list(a = 1:5, b = rnorm(10)
    > lapply(x, mean)
    $a 
    [1] 3
    $b
    [1] -0.5339087

Here is an example to supply additional arguments for the function:


    > lapply(x, runif, min = 0, max=10)
    [[1]]
    [1] 8.700355

    [[2]]
    [1] 4.628527 5.146968

    [[3]]
    [1] 0.6792626 3.8837029 1.6683086

    [[4]]
    [1] 5.315796 3.200593 7.428354 6.298550

`lapply` is often used together with _anonymous_ function. For example:

    x<-list(a = matrix(1:4, 2, 2), b = matrix(1:6, 3, 2))
    > x
    $a
         [,1] [,2]
    [1,]    1    3
    [2,]    2    4

    $b
         [,1] [,2]
    [1,]    1    4
    [2,]    2    5
    [3,]    3    6

We now use anonymous function to extract first column of two matrices:

    > lapply(x, function(elt) elt[,1])
    $a
    [1] 1 2

    $b
    [1] 1 2 3

## sapply

- if the result is a list where every element is length 1, then a vector is returned.

- if the result is a list where every element is a vector of same length (>1), a matrix is returned.

- if it can not figure things out, then a list is returned.

      > x = list(a = 1:5, b = rnorm(10))
      > sapply(x, mean)
          a         b 
      3.0000000 0.1616941 


## apply

      >str(apply)
      function(X, MARGIN, FUN, ...)


it is most often used to apply a function to rows or columns of a matrix.
it can be used with general arrays, e.g., taking average of an array of matrices.

1. The first argument is an array - array is a vector with dimension attributes attached to it.
2. MARGIN is an integer vector indicting which margins should be "retained"
3. FUN is a function to be applied.
4. `...` is for other arguments to be passed to FUN

Example: you want to calculate the mean of each column of the matrix. The row
is the 1st dimension, column is 2nd dimension. So the idea is to KEEP the 2nd
dimension (column), but collapse the 1st dimension, which is rows.

    > x = matrix(rnorm(200), 20, 10)
    > apply(x, 2, mean)
     [1] -0.04442183  0.10251515 -0.11095440  0.42190069  0.17947974  0.15175055 -0.35135826 -0.15084814  0.08944317 -0.01645822

So the matrix has 10 columns, the return is a vector of 10 as well. The first
dimension (rows) are collapsed and eliminated.

R provides optimized shortcuts for these operations:

    rowSums     = apply(x, 1, sum)
    rowMeans    = apply(x, 1, mean)
    colSums     = apply(x, 2, sum)
    colMeans    = apply(x, 2, mean)

## tapply

    > str(tapply)
    function(X, INDEX, FUN = NULL, ..., simplify=TRUE)

1. The first argument is a vector
2. INDEX is a factor or a list of factors
3. FUN is function to be applied

The following example has three groups, and `tapply` is used to tally mean for
each group.

    > x <- c(rnorm(10), runif(10), rnorm(10, 1))
    > f <- gl(3, 10)
    > f
     [1] 1 1 1 1 1 1 1 1 1 1 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 3 3 3
    Levels: 1 2 3
    > tapply(x, f, mean)
             1          2          3 
    -0.6661333  0.5481981  0.9223548 

The last group `rnorm(10, 1)` is 10 normal variables with mean of 1.

## split

`split` takes a vector or other objects and splits it into groups determined by
a factor or list of factors.

The following example return a list grouped by factors.

    > x <- c(rnorm(10), runif(10), rnorm(10, 1))
    > f <- gl(3, 10)
    > split(x,f)
    $`1`
     [1]  0.71988493 -0.24930518 -0.13313132  0.46834286 -1.63925505  0.76053059  1.10739907 -0.02960233
     [9] -1.56976721 -0.80293418

    $`2`
     [1] 0.1855789 0.4954799 0.4594475 0.6945067 0.3465347 0.3978193 0.9531468 0.3158040 0.6567237 0.5635957

    $`3`
     [1]  0.9688018  1.2977814  2.5327696  1.9746553  1.5770820  1.6647810 -0.7824982  1.2814013  1.1760134
    [10]  1.8214820
    > lapply(split(x,f), mean)

### Splitting a data frame


    > library(datasets)
    > head(airquality)
      Ozone Solar.R Wind Temp Month Day
    1    41     190  7.4   67     5   1
    2    36     118  8.0   72     5   2
    3    12     149 12.6   74     5   3
    4    18     313 11.5   62     5   4
    5    NA      NA 14.3   56     5   5
    6    28      NA 14.9   66     5   6
    
    # each month, there are many observations
    # I want to see the mean of Ozone, Solar, Wind for each month
    # so first, we split the dataset according to month
    
    s <- split(airquality, airquality$Month)

    # then, we use either lappy or sapply
    sapply(s, function(x) colMeans(x[, c("Ozone", "Solar.R", "Wind")], na.rm = TRUE)

Note how we use vector `c("Ozone" ... )` to select only the columns we want to apply mean.

### Splitting on More than one level

Sometimes, you want to study a combination of levels: for example, man and
woman as a factor group, race such as asian and american as another group.

    > x <- rnorm(10)
    > f1 <- gl(2, 5)
    > f2 <- gl(5, 2)

    > f1
     [1] 1 1 1 1 1 2 2 2 2 2
    Levels: 1 2
    > f2
     [1] 1 1 2 2 3 3 4 4 5 5
    Levels: 1 2 3 4 5
    > interaction(f1, f2)
     [1] 1.1 1.1 1.2 1.2 1.3 2.3 2.4 2.4 2.5 2.5
    Levels: 1.1 2.1 1.2 2.2 1.3 2.3 1.4 2.4 1.5 2.5
    > 

The combination of f1 and f2 is 2x5 which is 10 factor groups 
    x <- rnorm(10)
    > str(split(x, list(f1,f2), drop=TRUE))
    List of 6
     $ 1.1: num [1:2] -1.336 0.425
     $ 1.2: num [1:2] -0.356 -0.633
     $ 1.3: num 0.139
     $ 2.3: num -0.0441
     $ 2.4: num [1:2] 0.549 1.853
     $ 2.5: num [1:2] -0.897 0.602
       
Here you can see that you do not have to use `interaction`. The `split`
automatically calls it when you provide a list of factors. 
