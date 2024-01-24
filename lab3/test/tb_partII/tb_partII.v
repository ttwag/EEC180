module testBench;
    reg [8:0] test;
    wire [2:0] out0;
    wire [2:0] out1;
    wire [3:0] testOut;
    integer i;

    // Instantiate the 8-bit module and compute the output we want to test
    lzd8 mylzd8(.lzdIn(test[7:0]), .lzdOut(testOut));

    initial begin
        for (i = 0; i < 15; i = i + 1) begin
            test = $random % 9'b100000000;
            #5;
            $display("ERROR: Test = %b, Output = %b", test[7:0], testOut);
        end
        $display("Number of Test = %d", i);
    end
endmodule

