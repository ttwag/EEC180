# EEC180 Lab2 Report

## Pre-Lab

Boolean Equation of a 2-bit Full-Adder

co = (a & b) | (a & ci) | (b & ci)
s = a ^ b ^ ci

**Structural Model**
* Structural Model builds the actual gate structure in Verilog.

```
module seg_decoder (
    input
        [0] a,
        [0] b,
        [0] ci;
    output 
        [0] s,
        [0] co;
);

co = (a & b) | (a & ci) | (b & ci)
s = a ^ b ^ ci

endmodule
```

**Behavioral Model**
* Behavioral Model models the behavior of the gates with boolean equations without building the gates.

```
a + b
```

## PartI

When does the adder overflow?
* When a[7] and b[7] are 1 and sum[7] is 0.
* When a[7] and b[7] are 0 and sum[7] is 1.

| a[7] | b[7] | sum[7] | overflow |
| ---: | ----:| ----:| ---: |
| 0 | 0 | 0 | 0 |
| 0 | 0 | 1 | 1 |
| 0 | 1 | 0 | 0 |
| 0 | 1 | 1 | 0 |
| 1 | 0 | 0 | 0 |
| 1 | 0 | 1 | 0 |
| 1 | 1 | 0 | 1 |
| 1 | 1 | 1 | 0 |

