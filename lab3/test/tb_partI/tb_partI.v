module testBench;
    reg [4:0] test;
    wire [2:0] testOut;
    wire [2:0] correctOut;
    integer errorCount = 0;

    // Instantiate the lzd module
    lzd4 mylzd (.lzdIn(test[3:0]), .lzdOut(testOut[2:0]));

    // Assign the true output through behavioral statements
    assign correctOut[2] = (!test[0] & !test[1] & !test[2] & !test[3]);
    assign correctOut[1] = (!test[3] & !test[2] & test[0]) | (!test[3] & !test[2] & test[1]);
    assign correctOut[0] = (!test[3] & test[2]) | (!test[3] & !test[1] & test[0]);

    // Test all possible inputs
    initial begin
        $display("Test Begins:");
        for (test = 0; test < 2**4; test = test + 1) begin
            #5;
            if (testOut[2:0] != correctOut[2:0]) begin
                $display("ERROR: Test = %b, Correct Output = %b, Output = %b", test[3:0], correctOut, testOut);
                errorCount = errorCount + 1;
            end
        end
        $display("Number of Test = %d", test);
        $display("Error = %d", errorCount);
    end
endmodule