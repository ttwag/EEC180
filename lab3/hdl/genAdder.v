module genAdder #(parameter N = 1)
    (
        input [N-1:0] a, b,
        output [N-1:0] sum,
        output cout
    );

    // genAdder generates an N bit adder

    wire [N:0] carryIn;
    assign carryIn[0] = 1'b0;
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : genBlock
            fAdder add(.a(a[i]), .b(b[i]), .cin(carryIn[i]), .sum(sum[i]), .cout(carryIn[i+1]));
        end
    endgenerate
    assign cout = carryIn[N];
endmodule