module selfTestBench;
    // This self-checking test bench computes the lzd for 8-bit input in software, then compares it with the solution obtained from combinational logic


    // A function that computes the lzd for 8 bit input in software
    function automatic [3:0] lzdOut;
        input [7:0] lzdIn;
        integer j;
        reg exit = 0;
        begin
        lzdOut = 4'b0000;
            for (j = 0; (j < 8) && !exit; j = j + 1) begin
                if (lzdIn[7] == 0) begin
                    lzdOut = lzdOut + 4'b0001;
                end
                else begin
                    exit = 1;
                end
                lzdIn = lzdIn << 1;
            end
        end
    endfunction
    
    reg [8:0] test;
    reg [3:0] trueOut;
    wire [3:0] testOut;
    integer errorCount = 0;

    // Instantiate lzd8 module
    lzd8 mylzd8(.lzdIn(test[7:0]), .lzdOut(testOut));

    initial begin
        $display("Test Begins:");
        for (test = 0; test < 2**8; test = test + 1) begin
            trueOut = lzdOut(test[7:0]);
            #5;
            if (testOut != trueOut) begin
                $display("ERROR: Test = %b, Correct Output = %b, Output = %b", test[7:0], trueOut, testOut);
                errorCount = errorCount + 1;
            end
        end
        $display("Number of Test = %d", test);
        $display("Error = %d", errorCount);
    end
endmodule