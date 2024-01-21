module myMultiplier (
    input [1:0] a, b,
    output [3:0] product 
);
    wire f1;
    
    // Product[0]
    and(product[0], a[0], b[0]);
    
    // Product[1]
    mult m1 (
        .a0(a[1]),
        .a1(b[0]),
        .b0(a[0]),
        .b1(b[1]),
        .cin(1'b0),
        .s(product[1]),
        .cout(f1)
    );

    // Product[2]
    mult m2 (
        .a0(a[1]),
        .a1(b[1]),
        .b0(1'b0),
        .b1(1'b0),
        .cin(f1),
        .s(product[2]),
        .cout(product[3])
    );
endmodule