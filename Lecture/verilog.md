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
* **Integer**
* **Time**
* **Real**

### Representation of Number in Verilog
* Choosing just the right number of bits make more efficient hardware.
```
// Sized number
12'b101010101011 //12 bit binary
12'o4251        // 12 bit OCTAL
12'h8A9         // 12 bit hexadecimal

// Unsized number
`o4251           // No need to specify the number of bit

// Negative Sign
-4'b0101        // Two's complement representation, which is 1011
```

### Signed Arithmetic

```
reg signed [7:0] A          // A is signed 8 bit 2's complement

```

### Modeling Delay

```
nand#35(f1, a, b, c)    //#35 is the propagation delay

// The #35 also specifies how long the input must persist for the output to change.
```

### Watching Output
```$monitor``` : give it a list of variable. When one of them changes, it prints the information.

```
$monitor($time,,, "a=%b, b = %b,...)

// prints a = 0, b = 0, ...
```


### How to Test Our Design?
* Design using structral verilog and test using behavioral verilog.
* Design then verify with a reference written in high-level languages.


### Parameters
* A Parameter is a local constant that can be changed during the instantiation of the object

### Generate

Instantiate a bunch of modules and systematically connect them for hierarchical design.

```
module generateDemo();

genvar i;

generate for (i = 0; i <= 2; i = i + 1) begin
    moduleName instanceName (
        .input(input),
        .output(output)
    );
end
endmodule
```

### Behavior Modeling

**always statement**
* Inside ```always``` statement to denote hardware's concurrent nature.
* Everything inside always happens at the same time and never stops.
* Inside the ```always``` statement, the left-hand side of an assignment must be a ```reg```.
```
always () begin

    // Sequential statements
    // eg., assign a = b | c
    // eg., if else conditional statements

end
```


**Initial Statement**
* An ```always``` statement but only executes once and stops. 
* We need ```initial``` for initialization and writing testbench.

**Loops**
* The loop body must have a delay statement.

### Combinational Logic
* Each ```always``` statement is a boolean function.
* ```@``` means wait for some time.
* Every element of the input set must be in the sensitivity list.
* The combinational output must be assigned in every control path.


```
module blah (
    input a,b, c,
    output f,
    
    always @(a,b, c) begin
        ;
        ;
        ;
    end
endmodule
)
```

### D-Flip Flop

|D|Q|$Q^+$|
|-|-|-|
|0|0|0|
|0|1|0|
|1|0|1|
|1|1|1|

```
// Triggered in rising clock edge with active low asynchronous reset
// The sensitivity list in this example has synchronous input and asynchronous reset

module DFF
    (output reg q,
    input d, clk, reset);

    always@(posedge clk or negedge reset)
    if (~reset) 
        q <= 0;
    else 
        q <= d;
endmodule
```
We could also model a state machine in Verilog with the high-level state diagram.

```

// A state machine that has 3 states

module (
    input clk,
    input rst,
    input x,
    output Z
    );

    // One hot encoding
    reg state;
    neg nextstae
    localparam S2 = 3'd0;
    localparam S1 = 3'd1;
    localparam S0 = 3'd2;

    //State Machine
    always @(posedge clk or posedge rst) begin
        if (rst)
            state <= S0;
        else 
            state <= nextstate;
    end

    // State Transition
    always @(state, X) begin
        case(state)
            S0:begin
            end

            S1:begin
            end

            S2:begin
            end

            default
        endcase
    end
endmodule
```

**Test Bench Clock Generator**
```
forever begin
    #5 clk = 1; #5 clk = 0;
end 
```

### Simulation
* Discrete Time Simulation
    * Models evaluated and outputs updated every t time units even if input has not changed.
* Discrete Event Simulation
    * Verilog is a discrete event model.
    * Only evaluate when input changes.
    * Only execute something when an event has occurred at its input.
    * Events: a value-change scheduled to occur at a given time.
* **#:** delay a specific amount of time.
* **@:** delay until an event occurs (ex: posedge or negedge).
* **wait():** possibly delaying until an event occurs.

### Non-Blocking Assignment
* **<=**