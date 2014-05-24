# Fortran for me, the impatient

Here are couple of tutorials I found useful

* [Fortran 90 Tutorial, Standford](http://www.stanford.edu/class/me200c/tutorial_90/)

## Program structure

- Line may extend to 132 characters

- More than one statement can be placed on a line, use ; as delimiter

- `!` as comment character

- `implicit none` says program variables **must** be specified explicitly.

- Declare variables:

      REAL      :: area = 0.
      INTEGER   :: month = 12

- Declare parameter (constant):

      REAL, PARAMETER :: Pi = 3.14


- The separator `::` is required in type specification statement when you
  declare **and** initialize a variable, or to declare a special attribute
  such as `PARAMETER`, otherwise, it can omitted.

      REAL  area

- Program composition

      PROGRAM name
        declarations
        executable statements
      END PROGRAM

## Control Structure

### IF-ELSE

        IF (logical argument) THEN
          statements
        ELSE IF (logical argument) THEN
