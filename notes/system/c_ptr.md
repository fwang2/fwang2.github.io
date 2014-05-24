# C Pointers

This brief guide summarizes C pointer usage.

## Pointer to Pointer

When a pointer is passed to a function, it is passed by value. That means, if
we want to modify the **original** pointer and not the copy of the pointer, we
need to pass it as _a pointer to a pointer_.

The following example (from Reese book) shows how we pass in a pointer to an
integer array, and the function will allocate memory. The address of newly
allocated memory is assigned to a pointer to a `int`.

    void allocateArray(int **arr, int size, int value) {
        *arr = (int*) malloc(size * sizeof(int));
        if (*arr == NULL) {
            for (int i=0; i<size; i++)
                *(*arr+i) = value;
        }
    }

    # to use it
    int * vec = NULL;
    allocateArray(&vec, 100, 0);

At this point, `vec` is holding the address pointing to newly allocated memory
by the function. The best mental practice here is to *think* why passing in a
simple pointer such as `int *arr` won't work here - meaning you can't get the
`malloc()`ed address back to the caller by:

    arr = (int*) malloc(size * sizeof(int));

The key to remember here is **copy by value**, modifying `arr` has no bearing
on `vec`. As soon as the function  `allocateArray` returns, `arr` value
pointing to some place in the heap is lost in the wind. 

## Function pointer

A function pointer is a pointer that holds the address of a function.

### Declare a function pointer

    int     (*fooptr) (int);
    ---     -----      --- 
     |        |         | 
     |        |         |
     |        |        passed an integer
     |      Function pointer's variable name 
    Return type: an integer

### Use a function pointer

    int square(int num) {
        return num*num;
    }

    int n = 5;
    fooptr = square;
    printf("%d sqaured is %d\n", n, fooptr(n));

### Use `typedef` for function pointer 

It is convenient to declar a type definition for function pointer.

    typedef int (funcptr)(int);
    funcptr fooptr;
    fooptr = square;
    printf("%d sqaured is %d\n", n, fooptr(n));


### Passing function pointers

The following example demonstrate the use of a function pointer declaration as
a parameter of a function.


    int add(int n1, int n2) { return n1 + n2; }
    int subtract(int n1, int n2) {return n1 - n2;}
    typedef int (*fptrArithmaticsOps)(int, int);
    int compute(fptrArithmaticsOps ops, int n1, int n2) { return ops(n1, n2)}

    /* now we make use of above */
    printf("%d\n", compute(add, 1, 2));
    printf("%d\n", compute(subtract, 3, 1));


### Return function pointer

Another interesting example from Reese's book: declaring the function's return
type as function pointer.

    fptrArithmaticsOps select(char opcode) {
        switch(opcode) {
        case '+': return add;
        case '-': return subtract;
        }
    }

    int evaluate(char opcode, int n1, int n2) {
        fptrArithmaticsOps operation = select(opcode);
        return operation(n1, n2);
    }

    /* example */
    fprintf("%d\n", evaluate('+', 1, 2));

### Array of function pointers

Array of function pointers are often used for selecting a function to evaluate
based on some kind of criteria.

To declare:

    typedef int (*ArithmaticOps)(int, int);
    ArithmaticOps ops[4] = {NULL};   

Alternatively:

    int (*ops[4])(int, int) = {NULL}


 Note here ``NULL`` will be assigned to each element of the array.


## Array and Pointer

The array name simply references a block of memory, and internal
representation of an array have no information about the number of elements it
contains.

Therefore, `sizeof` operator on array name returns the number of bytes
allocate to the array. To determine the number of elements, we divide the
arrays's size by its element's size.

**Two dimension array**: this type of array needs to be mapped to the
one-dimension address space of main memory. The array's first row is placed in
memory, followed by second row, until the last row is placed.

### Pointer and Array notation are similar but not the same.

When an array name is used by itself, the array's address is returned, we can
assign this address to a pointer as such:

    int vector[5] = { 1, 2,3,4,5};
    int *pv = vector;

The variable `pv` is a pointer to the first element of the array and not the
array itself.

    (1) printf("%p\n", vector);
    (2) printf("%p\n", &vector[0]);
    (3) printf("%p\n", &vector);
    (5) printf("%d\n", sizeof vector);
    (6) printf("%d\n", sizeof pv);

(1) and (2) are equivalent: both return the address of `vector`, or more
precisely, pointer to an integer. The (3) returns a pointer to **the entire
array**. 

(5) will return 20, the number of bytes allocated the array; (6) will return
4, the pointer's size. The pointer `pv` is a *lvalue*, which can on modified;
An array's name is not a *lvalue*, and can NOT be modified.

    pv = pv + 1; // fine
    vector = vector + 1; // no no






### Richard explains: `vector[2]` and `&vector[2]`

Richard said the first notation can read as **shift and dereference**:
`vector[2]` starts with address of `vector`, which is a pointer to the
beginning of the array, shift two positions to the right, and then dereference
the location to fetch its value; The notation `&vector[2]` with that
*address-of* operator, cancels out the dereferencing. After the shift, it
returns that address at that position.


### Array of Pointers

Try to follow the two code snippets here: we declare an array of *integer*
pointers, allocate memory for each element and initialize the memory to array
index.

    int* arr[5];
    for (int i=0; i<5; i++) {
        arr[i] = malloc(sizeof(int));
        *arr[i] = i;
    }

The equivalent pointer notation for loop is:

    *(arr+i) = malloc(sizeof(int));
    **(arr+i) = i;

If you follow it without much mental effort, then you are fine.

    

## Pointer and Multidimensional Array

Two dimension array can be initialized as the following:

    int matrix[2][5] = { {1, 2, 3, 4, 5}, {6, 7, 8, 9, 10}};

The memory layout follows **row-column**: lay down the first row first, then
second row and so on.

We can also declare a pointer to use with this array:

    int (*pmatrix)[5] = matrix;

`pmatrix` is defined as a pointer to a 2D array of integers with 5 elements
per column. Note that the parentheses around `*pmatrix` is must; Also note
that we did not say the number of rows, this is implicit knowledge `pmatrix`
must follow.

    (1) printf("%p\n", matrix);
    (2) printf("%p\n", matrix+1);
    (3) printf("%p\n", matrix[0]);
    (4) printf("%p\n", matrix[1]);

(1) and (3) output address starting at first element of first row of this
matrix; (2)and (4) output address starting at first element of **second** row
of this matrix. The offset is 20 bytes, since you have 5 integers in between.

### Two forms of passing a multidimensional array

    (1) void display2d(int arr[][5], int row) { ... }
    (2) void display2d(int (*arr)[5], int row) { ... }

The key point is: when you pass 2D array, you supply the number of columns
(2nd dimension) in your declaration; when you pass 3D array, you will supply
2nd and 3rd dimension in your declaration. For example:

    (3) void display3d(int (*arr)[2][4], int rows) { ... }

There should be plenty of examples on Internet for this usage.

### Dynamically allocate memory for 2D array

There are some fine discussion on this in Reese's book, P.99


## Useful References:

1. [C FAQ](http://c-faq.com/)
2. Richard Reese, "Understanding and Using C pointer", 2013
3. Kenneth Reek, "Pointers on C", 1997
4. [The Descent to C](http://www.chiark.greenend.org.uk/~sgtatham/cdescent/),
by Simon Tatham

