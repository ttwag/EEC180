module tBench;
	wire [7:0]sum; 
	wire cout;
	wire overflow;
	reg [16:0]test;
	integer errorCount = 0;
	// design under test;
partI_add FA (test[15:8], test[7:0], sum[7:0], cout, overflow);
// stimulus and verification that the output is correct
	initial begin
		$display("Testing Begins:");
		for (test = 0; test < 2**16; test = test + 1) begin
			#10;
			if ({cout, sum[7:0]} != (test[15:8] + test[7:0])) begin
				$display("ADDITION ERROR: a=%b b=%b sum=%b cout=%b", test[15:8], test[7:0], sum[7:0], cout);
				errorCount = errorCount + 1;
			end
			else if (overflow != ((!test[15] & !test[7] & sum[7]) | (test[15] & test[7] & !sum[7]))) begin 
				$display("OVERFLOW ERROR: a=%b b=%b sum=%b cout=%b, overflow=%b", test[15:8], test[7:0], sum[7:0], cout, overflow);
				errorCount = errorCount + 1;
			end
		end
		$display("Error: %d", errorCount);
		$display("number of Test Cases: %d", test);
//		$finish;
	end
endmodule
