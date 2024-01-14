module tb_partII;
	reg [3:0] count;
	wire [7:0] HEX0;
	wire [7:0] HEX1;
	wire [7:0] HEX2;
	wire [7:0] HEX3;
	wire [7:0] HEX4;
	wire [7:0] HEX5;
	wire [9:0] LEDR;
	wire [9:0] SW;

	assign SW[3:0] = count;
	partII UUT (.HEX0(HEX0), .HEX1(HEX1), .HEX2(HEX2),
		.HEX3(HEX3), .HEX4(HEX4), .HEX5(HEX5),
		.LEDR(LEDR), .SW(SW));
	initial begin
	  count = 4'b0000;
	  repeat (16) begin
		#100
		$display("in = %b, out = %b", count, HEX0[7:0]);
		$display("in = %b, out = %b", count, HEX1[7:0]);
		count = count + 4'b0001;
	  end
	end
endmodule
