module mult (
    input a0, a1, b0, b1, cin,
    output s, cout
);
    //a, b
    and(a, a0, a1);
    and(b, b0, b1);
    
    //cout
    and(w1, a, b);
    and(w2, a, cin);
    and(w3, b, cin);
    or(w4, w1, w2);
    or(cout, w3, w4);

    //sum
    xor(w5, a, b);
    xor(s, w5, cin);
endmodule