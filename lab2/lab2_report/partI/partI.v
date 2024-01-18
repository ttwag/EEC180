
//=======================================================
//  This code is generated by Terasic System Builder
//=======================================================

module partI(

	//////////// LED //////////
	output		     [9:0]		LEDR,

	//////////// SW //////////
	input 		     [9:0]		SW
);

endmodule

//=======================================================
//  REG/WIRE declarations
//=======================================================




//=======================================================
//  Structural coding
//=======================================================

module partI_add (
	input 
	[7:0] a,b,
	
	output [7:0] sum,
	output cout,
	output overflow
); 

// Carry out
wire out0;
wire out1;
wire out2;
wire out3;
wire out4;
wire out5;
wire out6;


// Bit 0
fAdder partI_adder0 (
	.a(a[0]),
	.b(b[0]),
	.cin(1'b0),
	.sum(sum[0]),
	.cout(out0)
);

 

// Bit 1
fAdder partI_adder1 (
	.a(a[1]),
	.b(b[1]),
	.cin(out0),
	.sum(sum[1]),
	.cout(out1)
);

// Bit 2
fAdder partI_adder2 (
	.a(a[2]),
	.b(b[2]),
	.cin(out1),
	.sum(sum[2]),
	.cout(out2)
);

// Bit 3
fAdder partI_adder3 (
	.a(a[3]),
	.b(b[3]),
	.cin(out2),
	.sum(sum[3]),
	.cout(out3)
);

// Bit 4
fAdder partI_adder4 (
	.a(a[4]),
	.b(b[4]),
	.cin(out3),
	.sum(sum[4]),
	.cout(out4)
);

// Bit 5
fAdder partI_adder5 (
	.a(a[5]),
	.b(b[5]),
	.cin(out4),
	.sum(sum[5]),
	.cout(out5)
);

// Bit 6
fAdder partI_adder6 (
	.a(a[6]),
	.b(b[6]),
	.cin(out5),
	.sum(sum[6]),
	.cout(out6)
);

// Bit 7
fAdder partI_adder7 (
	.a(a[7]),
	.b(b[7]),
	.cin(out6),
	.sum(sum[7]),
	.cout(cout)
);


// Check Overflow

assign overflow = (!a[7] & !b[7] & sum[7]) | (a[7] & b[7] & !sum[7]);

endmodule
