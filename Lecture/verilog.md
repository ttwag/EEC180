# Introduction to Verilog

## Digital Design Flow
Reuirements -> Design Specification -> Design Formulation (System Architecture) -> Design Entry (VHDL ,Verilog) -> Simulation -> Logic Synthesis (Compile Verilog) -> Post Synthesis Simulation -> Mapping, Placement , Routing -> FPGA, ASIC

## Why not Use C?
* Hardware is concurrent, C is sequential.
* C has no support for hardware abstractions like registers, clocks, structural hierarchy, and timing.

## Verilog
* Case Sensitive
* White Space Ignored
* Multiple Statements could be on the same line
* ```//``` for comment

### Example
f = (x1 & x2) | (!x2 & x3) = g | h

**Structual Model**
* You build the gates in Verilog.
* Quite tedious for a large circuit.

```
module example1 (x1, x2, x3, f);
    input x1, x2, x3;
    output f;

    and(g, x1, x2);
    not(k, x2);
    and(h, k, x3);
    or(f, g, h);

endmodule
```

**Behavior Model**
* More compact
* Assign Statement concurrency: if anything on right hand side changes, f will be re-evaluated
```
modeule example3(x1, x2, x3, f);
    input x1, x2, x3;
    output f;
    assign f = (x1 & x2) | (!x2 & x3);
endmodule
```

```
// Another way with higher abstraction
// Always statement to run concurrently 
// Reg means the output could be a register that needs memory allocation. Ouput needs to be a reg for always@
// (x1 or x2 or x3) is the sensitivity list that hardware is sensitive to changes in these inputs

module example5(x1, x2, x3, f);
    input x1, x2, x3;
    output f;
    reg f;
    always @(x1 or x2 or x3) 
        if (x2 == 1)
            f = x1;
        else 
            f = x3;
endmodule
```



### Module
* Basic Entity in Verilog that tells input output.
* Like class in C++.
* ```#``` specifies the delay of a gate.

### Verilog Value
* A bit could take the value: 0, 1, x (**undefined**), z (high impedance open circuit)

### Verilog DataType
* **Net**: establish output and input.
    * Wire
    * Bus
```
//EX

wire n1            //Single wire
wire[3:0] dbus     // a 4-bit bus with 0 as LSB
```
* **Reg**: like a variable.
    * ```reg [9:0]r1        //r1 is a 10-bit register```