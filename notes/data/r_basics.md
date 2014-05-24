# R Basics 

There are a few things we need to learn before dive into R.

- data type
- data transformation
- data processing
- data visualization


## Data Types

R has five basic 'atomic' classes of objects:

1. character
2. numeric (real numbers)
3. integer
4. complex
5. logical (True/False)


### Vector

The most basic object is a vector:

- A vector can only contain objects of the same class. Empty vector can be
  created by `vector()` function.
- BUT, there is one exception, `list`, which is represented as a vector, but
  can contain objects of different classes.



### Number

Numbers in R is treated as numeric objects. `NaN` is undefined number; `Inf`
represents infinity.

### Attributes

R object can have attributes: such as names, dim names, dimensions, class,
length etc. Attributes of an object can be accessed using `attributes()`
function.

### Creating Vector

#### The `c()` function can be used to create vectors of objects:

    x <- c(0.5, 0.6)        ## numeric
    x <- c(TRUE, FALSE)     ## logical
    x <- c(T, F)            ## logical
    x <- 9:29               ## integer

#### Use the `vector()` function:

    x <- vector("numeric", length=10)
    > x
    [1] 0 0 0 0 0 0 0 0 0 0

#### Mixing Object

    > y <- c(2.7, "b")      ## character
    > y
    [1] "2.7" "b"  

R coerces 2.7 to "2.7" so that every element in the vector is of the same
class.

#### Explicit coercion with `as()` function

    > x <- 0:6
    > class(x)
    [1] "integer"
    > as.numeric(x)
    [1] 0 1 2 3 4 5 6
    > as.logical(x)
    [1] FALSE  TRUE  TRUE  TRUE  TRUE  TRUE  TRUE
    > as.character(x)
    [1] "0" "1" "2" "3" "4" "5" "6"
     
When coercion does not work, `NA` is returned.

### Matrices

Matrices are vectors with a _dimension_ attributes. The dimension attribute is
itself an integer vector of length 2 (nrow, ncol).

    > m <- matrix(nrow = 3, ncol = 3)
    > attributes(m)
    $dim
    [1] 3, 3

Matrices are constructed _column-wise_. 

#### Creating matrix by adding dimension attributes

    > m = 1:12
    > dim(m) = c(3,4)
    > m
         [,1] [,2] [,3] [,4]
         [1,]    1    4    7   10
         [2,]    2    5    8   11
         [3,]    3    6    9   12

#### cbind-ding and rbind-ing

Matrices can be created by _column-binding_ or _row-binding_ with `cbind()`
and `rbind()`.

    > x <- 2:4
    > y <- 7:9
    > cbind(x,y)
         x y
         [1,] 2 7
         [2,] 3 8
         [3,] 4 9
    > rbind(x,y)
         [,1] [,2] [,3]
           x    2    3    4
           y    7    8    9


### Lists

Elements of the list are indexed with double brackets.

    x <- list(1, "a", TRUE, 1 + 4i)


### Factors

Factor is a special vector that is used to represent _categorical_ data.
Factors can be ordered or unordered. One can think of a factor as as integer
vector where each integer has a _label_.


Using factors with labels is _better_ than using integers becauses factors are
self-describing.
    
    > x <- factor(c("yes", "yes", "yes", "no"))
    > x
    [1] yes yes yes no 
    Levels: no yes
    > table(x)      ## frequency count
    x
     no yes 
       1   3 
    > unclass(x)    ## stripe out a class
    [1] 2 2 2 1     ## yes is coded as 2, no is coded as 1
    attr(,"levels")
    [1] "no"  "yes"

The order of the levels can be set using `levels` argument to `factor()`. The
can be important in linear modeling because the first level is used as the
baseline level.

    > x <- factor(c("yes", "yes", "yes", "no"), levels=c("yes","no"))
    > x
    [1] yes yes yes no 
    Levels: yes no

Note that the levels print out is different from without levels options.

### Data Frames

Data frames are used to store tabular data. It is represented by a special
type of list where every element of the list has to have the same **length**.
Each element of the list can be thought of as a column, and the length of each
element of the list is the number of rows.

Unlike matrices, data frames can store different classes of object in each
column. Data framework also have a special attribute called `row.names`.

Data frames are usually created by calling `read.table()` or `read.tables()`.
A data frame can be converted to a matrix by `data.matrix()`.

    > x <- data.frame(foo=1:3, bar=c(T, F, F))
    > x
      foo   bar
      1   1  TRUE
      2   2 FALSE
      3   3 FALSE
      > nrow(x)
      [1] 3
      > ncol(x)
      [1] 2


### Names

Not only data frame, other R object can have names as well. This is useful for
creating self-describing data.

For example:

    > m <- matrix(1:4, nrow=2, ncol=2)
    > dimnames(m) <- list(c("a", "b", c("c", "d"))
    > m
        c d
    a   1 3
    b   2 4



## Data Manipulation

### Subsetting

- [  return object of the same class as the original, so if you
  subset a vector, you get back a vector.

- [[ is used to extract a SINGLE elements of a list or data frame.

- $ is used to extract element of a list or data frame by NAME


#### Subsetting through numeric index and logical index

    "a", "b", "c", "c", "d", "a")
    > x[1:4]
    [1] "a" "b" "c" "c"
    > x[x>"a"]
    [1] "b" "c" "c" "d"
    > u <- x > "a"
    > u
    [1] FALSE  TRUE  TRUE  TRUE  TRUE FALSE
    > x[u]
    [1] "b" "c" "c" "d"

#### Subsetting a matrix

    > x <- matrix(1:6, 2, 3)
    > x
        [,1] [,2] [,3]
        [1,]    1    3    5
        [2,]    2    4    6
    > x[1, ]
        [1] 1 3 5
    > x[, 2]
        [1] 3 4

#### Subsetting a list

    > x <-list(foo=1:4, bar=0.6)
    > x[1]          # [ return same class: a list with sequence 1 to 4.
    $foo
    [1] 1 2 3 4
    
    > x[[1]]        # [[ return just the sequence
    [1] 1 2 3 4     

    > x$bar         # use $ with name
    [1] 0.6

#### Use [[ operator to compute index

    > x <- list(foo = 1:4, bar = 0.6, baz = "hello")
    > name <- "foo"
    > x[[name]]     # you can not use x$name to get it
    [1] 1 2 3 4

#### Example: Use logical index remove NA value

    > x <-c (1, 2, NA, 4, NA, 5]
    > bad <- is.na(x)
    > x[ !bad ]
    [1] 1 2 4 5


## Data Manipulation II

### Order/sort data frame

Say you have a data frame `df`, you want it to order on the first column, all
you need to do is pass the column (`df[,1]`) to `order()` function.


    df = df[order(df[,1]) ,]


## Read and Write Data

- `read.table` and `read.csv` for tabular data (`write.table`)
- `readLines` for reading lines of text file (`writeLines`)
- `source` for reading in R code, (inverse of `dump`)
- `dget` for reading in R code, (inverse of `dput`)
- `load` for reading in saved workspaces (`save`) 
- `unserialize` for reading single R object in binary form (`serialize`)

### `read.table` details

- `file`: name of the file
- `header`: logical indicating if the file has a header, `read.csv` default is
  True
- `sep`: a string indicating how columns are separated, default is space,
  where `read.csv` default this as comma.
- `colClasses`: a character vector indicating the class of each column in the
  dataset
- `nrows`: number of rows in the dataset
- `comment.char`: a character string indicating a comment character, R auto
  skip #
- `skip`: the number lines to skip in the beginning
- `stringAsFactors`: should character variable be coded as factors, default as
  True

### Reading larger dataset

Use the `colClasses` argument, which make it MUCH faster.

    initial <- read.table("data.txt", nrows=100)
    classes <- sapply(initial, class)
    tabAll <- read.table("data.txt", colClasses = classes)

### Dump R object

    > x <- "foo"
    > y <- data.frame(a = 1, b = "a")
    > dump( c("x", "y"), file = "data.R")  
    > rm(x,y)
    > source("data.R")
    > x
    [1] "foo"


