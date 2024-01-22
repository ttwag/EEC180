module lzd4 (
    input
        [3:0] lzdIn,
    output
        [2:0] lzdOut
);

    // Create negated inputs
    not(w1, lzdIn[0]);
    not(w2, lzdIn[1]);
    not(w3, lzdIn[2]);
    not(w4, lzdIn[3]);

    // lzdOut[2]
    and(f1, w1, w2);
    and(f2, w3, w4);
    and(lzdOut[2], f1, f2);
    
    // lzdOut[1]
    and(f3, f2, lzdIn[0]);
    and(f4, f2, lzdIn[1]);
    or(lzdOut[1], f3, f4);

    // lzdOut[0]
    and(f5, w4, lzdIn[2]);
    and(f6, w4, w2);
    and(f7, f6, lzdIn[0]);
    or(lzdOut[0], f5, f7);

endmodule