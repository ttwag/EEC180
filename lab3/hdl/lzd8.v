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

    // if any of the lzdIn[7:4] is 1, then lzdSum0 is 0
    // Set flag to 0 whenever lzdIn[7:4] >= 1, and to 1 whenever lzdIn[7:4] == 0
    not(w1, lzdIn[7]);
    not(w2, lzdIn[6]);
    not(w3, lzdIn[5]);
    not(w4, lzdIn[4]);
    and(f1, w1, w2);
    and(f2, w3, w4);
    and(flag, f1, f2);

    // Use lzdSum0_1's value only if lzdIn[3:0] is 0000
    assign lzdSum0_2 = lzdSum0_1 & {3{flag}};

    // Add the two detected number of zeroes
    genAdder #(.N(N)) add3 (.a(lzdSum1), .b(lzdSum0_2), .sum(lzdOut[2:0]), .cout(lzdOut[3]));

endmodule