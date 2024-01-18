// Create a 1-bit full adder

module fAdder (
	input a, b, cin,
	output sum, cout
);

assign {cout, sum} = a + b + cin;

endmodule