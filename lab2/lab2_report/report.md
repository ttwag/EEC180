# EEC180 Lab2 Report

## Pre-Lab

Boolean Equation that decodes the segment 5 of the HEX1 display in a 4-bit input:

HEX1[5] = (SW[3] & SW[1]) | (SW[3] & SW[2])

**Structural Model**
* Structural Model builds the actual gate structure in Verilog.

```
module seg_decoder (
    input [3:0] sw,
    output [5] hex1;
);

and(g, sw[3], sw[1]);
and(f, sw[3], sw[2]);
or(hex1, g, f);

endmodule
```

**Behavioral Model**
* Behavioral Model models the behavior of the gates with boolean equations without building the gates.

```
module seg_decoder (
    input [3:0] sw,
    output [5] hex1;
);
assign hex1[5] = (sw[3] & sw[1]) | (sw[3] & sw[2]);

endmodule
```
