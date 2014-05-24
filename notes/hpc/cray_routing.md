# Understand 3D Torus and Cray Routing




## Hardware
Cray system unit is cabinet, multiple cabinets are organized into rows and columns.

Each cabinet (XK) has 3 chassis: 0, 1, 2. Each Chassis has 8 blades (0..7). There are two types of blade we care about here:

* **Compute blade**: Each compute blade has two Gemini ports and 4 compute nodes, each compute node has 16 cores. So all together, we have 64 cores per blade.

* **Router blade**: AKA XIO service blade, it has 4 I/O node (AMD Operon 2000 series]) each with FDR IB connection. The peak I/O bandwidth is 32GB/s 


The bottom of the cabinet is for cooling purpose.



## Routing

There are 3 dimensions to consider: X, Y, Z

1. X dimension goes along rows
2. Y dimension goes along columns
3. Z dimension goes between blades inside the cabinet

If we assume:

    dim(X) = 0..24 = 25
    dim(Y) = 0..15 = 16
    dim(Z) = 0..23 = 24
    
Then, we are looking at a Torus network of:

	dim(X) * dim(Y) * dim(Z) = 9600
	




