module testBench;
    reg [8:0] test;
    wire [2:0] out0;
    wire [2:0] out1;
    wire [3:0] testOut;
    wire [3:0] correctOut;
    integer i, errorCount = 0;
    
    // Instantiate the 4 bit module and compute the correct output
    lzd4 mylzd0(.lzdIn(test[3:0]), .lzdOut(out0[2:0]));
    lzd4 mylzd1(.lzdIn(test[7:4]), .lzdOut(out1[2:0]));

    // Instantiate the 8-bit module and compute the output we want to test
    lzd8 mylzd8(.lzdIn(test[7:0]), .lzdOut(testOut));
    assign correctOut[3:0] = out1[2:0] + ({3{(!test[7] & !test[6] & !test[5] & !test[4])}} & out0[2:0]);

    initial begin
        for (i = 0; i < 2**8; i = i + 1) begin
            test = $random % 9'b100000000;
            #5;
            if (correctOut != testOut) begin
                $display("ERROR: Test = %b, Correct Output = %b, Output = %b", test[7:0], correctOut , testOut);
                errorCount = errorCount + 1;
            end
        end
        $display("Number of Test = %d", i);
        $display("Error = %d", errorCount);
    end
endmodule