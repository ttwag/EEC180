module tBench;
	wire [1:0]sum, co;
	reg [3:0]test;
	integer errorCount = 0;
	// design under test;
partI_add FA (sum[1:0], co, test[3:2], test[1:0]);
// stimulus and verification that the output is correct
initial begin
	for (test = 0; test < 16; test = test + 1)
	begin
		#10;
		if ({co, sum[1], sum[0]} != (test[3:2] + test[1:0]))
			$display("ERROR: a=%b b=%b sum=%b cout=%b", test[1], test[0], sum, co);
			errorCount++;
		end
		#10 $finish;
	end
	$display("Error: %d", errorCount);
endmodule
