module testBench;
    // Initialization
    parameter N = 6;
    // k is the amount of possible input
    parameter k = N * 2;
    reg [k:0] test;
    wire out;
    wire [N-1:0] sum;
    integer errorCount = 0;

    // Instantiation of the module to be tested
    genAdder #(.N(N)) FA(.a(test[(k-1):(k/2)]), .b(test[(k/2-1):0]), .sum(sum[(N-1):0]), .cout(out));

    initial begin
        $display("Test for N = %d", N);
        for (test = 0; test < 2**k; test = test + 1) begin
            #5;
            if ({out, sum} == test[k-1:k/2] + test[k/2-1:0]) begin
                $display("ERROR: a = %b, b = %b, Output = %b, Correct Output = %b", test[(k-1):(k/2)], test[(k/2-1):0],{out, sum}, test[k-1:k/2] + test[k/2-1:0]);
                errorCount = errorCount + 1;
            end
        end
        $display("Number of Test = %d", test);
        $display("Error = %d", errorCount);
    end
endmodule