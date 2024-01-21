module mult4(
    input [15:0] i,
    output [3:0] sum,
    output out
    );
    wire f0, f1, f2;

    mult m1 (
        .a0(i[0]),
        .a1(i[1]),
        .b0(i[2]),
        .b1(i[3]),
        .cin(1'b0),
        .s(sum[0]),
        .cout(f0)
    );

    mult m2 (
        .a0(i[4]),
        .a1(i[5]),
        .b0(i[6]),
        .b1(i[7]),
        .cin(f0),
        .s(sum[1]),
        .cout(f1)
    );

    mult m3 (
        .a0(i[8]),
        .a1(i[9]),
        .b0(i[10]),
        .b1(i[11]),
        .cin(f1),
        .s(sum[2]),
        .cout(f2)
    );

    mult m6 (
        .a0(i[12]),
        .a1(i[13]),
        .b0(i[14]),
        .b1(i[15]),
        .cin(f2),
        .s(sum[3]),
        .cout(out)
    );


endmodule