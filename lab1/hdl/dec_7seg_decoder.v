module dec_7seg_decoder
(
	input [3:0]
		bin,
	output [7:0]
		hex0,
		hex1
);

// Logic
// HEX0[7:0]
assign hex0[7] = 1

assign hex0[6] = (!bin[3] & !bin[2] & !bin[1]) | (bin[3] & !bin[2] & bin[1]) | (!bin[3] & bin[2] & bin[1] & bin[0])

assign hex0[5] = (!bin[3] & !bin[2] & bin[0]) | (!bin[3] & !bin[2] & bin[1]) | (!bin[3] & bin[1] & bin[0]) | (!bin[2] & bin[1] & bin[0]) | (bin[3] & bin[2] & !bin[1])

assign hex0[4] = (bin[0]) | (!bin[3] & bin[2] & !bin[1]) | (bin[3] & bin[2] & bin[1])

assign hex0[3] = (!bin[2] & !bin[1] & bin[0]) | (bin[3] & !bin[2] & bin[0]) | (!bin[3] & bin[2] & !bin[1] & !bin[0]) | (!bin[3] & bin[2] & bin[1] & bin[0]) | (bin[3] & bin[2] & bin[1] & !bin[0])

assign hex0[2] = (!bin[3] & !bin[2] & bin[1] & !bin[0]) | (bin[3] & bin[2] & !bin[1] & !bin[0])

assign hex0[1] = (!bin[3] & bin[2] & !bin[1] & bin[0]) | (!bin[3] & bin[2] & bin[1] & !bin[0]) | (bin[3] & bin[2] & bin[1] & bin[0])

assign hex0[0] = (!bin[3] & !bin[2] & !bin[1] & bin[0]) | (!bin[3] & bin[2] & !bin[1] & !bin[0]) | (bin[3] & !bin[2] & bin[1] & bin[0]) | (bin[3] & bin[2] & bin[1] & !bin[0])

// hex1[7:0]
assign hex1[7] = 1

assign hex1[6] = 1

assign hex1[5] = (bin[3] & bin[1]) | (bin[3] & bin[2])

assign hex1[4] = hex1[5]

assign hex1[3] = hex1[5]

assign hex1[2] = 0

assign hex1[1] = 0

assign hex1[0] = hex1[5]

endmodule
