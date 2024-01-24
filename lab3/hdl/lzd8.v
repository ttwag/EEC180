module lzd8 (
    input [7:0] lzdIn,
    output [3:0] lzdOut
);
    wire [2:0] lzdSum1;
    wire [2:0] lzdSum0_1;
    wire [2:0] lzdSum0_2;
    wire flag;

    // We need a 3-bit adder
    parameter N = 3;

    // Instantiate the modules
    lzd4 lzd1(.lzdIn(lzdIn[7:4]), .lzdOut(lzdSum1));
    lzd4 lzd0(.lzdIn(lzdIn[3:0]), .lzdOut(lzdSum0_1));

    // Use lzdSum0_1's value only if lzdIn[7:4] is 0000
    assign lzdSum0_2 = lzdSum0_1 & {3{lzdSum1[2]}};

    // Add the two detected number of zeroes
    genAdder #(.N(N)) add3 (.a(lzdSum1), .b(lzdSum0_2), .sum(lzdOut[2:0]), .cout(lzdOut[3]));

endmodule