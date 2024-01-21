module myMultiplier (
    input [3:0] a, b,
    output [7:0] product 
);
    wire [3:0] sum1, sum2, sum3;
    wire f1, f2;

    // product[0]
    and(product[0], a[0], b[0]);
    
    // First row, product[1]
    mult4 a1 (
        .i({a[3], b[1], 1'b0, 1'b0, a[2], b[1], a[3], b[0], a[1], b[1], a[2], b[0], a[0], b[1], a[1], b[0]}),
        .sum(sum1),
        .out(f1)
    );

    assign product[1] = sum1[0];

    // Second row, product[2]
    mult4 a2 (
        .i({a[3], b[2], f1, 1'b1, a[2], b[2], sum1[3], 1'b1, a[1], b[2], sum1[2], 1'b1, a[0], b[2], sum1[1], 1'b1}),
        .sum(sum2),
        .out(f2)
    );

    assign product[2] = sum2[0];

    // Third row, product[7:3]
    mult4 a3 (
        .i({a[3], b[3], f2, 1'b1, a[2], b[3], sum2[3], 1'b1, a[1], b[3], sum2[2], 1'b1, a[0], b[3], sum2[1], 1'b1}),
        .sum(sum3),
        .out(product[7])
    );

    assign product[3] = sum3[0];
    assign product[4] = sum3[1];
    assign product[5] = sum3[2];
    assign product[6] = sum3[3];

endmodule