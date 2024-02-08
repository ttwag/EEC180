module lab4_2;
    // N is the bit length of the sequence
    parameter N = 20;

    // Input Sequence
    reg [N-1:0]sequence;
    
    // Software Detector's output
    reg [N-1:0]out;
    
    // Hardware Detector's input and output
    reg inH, clk, rst;
    wire outH;

    seqDetector detectorH(.in(inH), .clk(clk), .rst(rst), .out(outH));

    integer counter, error;

    // The detector function returns the output of the sequence detector
    function [N-1:0] detector(input [N-1:0]in);
        integer i, j, k, b;
        integer flag;
        begin
            detector = {N{1'b0}};
            i = 0;
            j = 1; 
            flag = 0;
            for (k = 2; k < N && flag == 0; k = k + 1) begin
                if (in[i] == 1'b0 && in[j] == 1'b0 && in[k] == 1'b0) flag = 1;
                else if (in[i] == 1'b0 && in[j] == 1'b0 && in[k] == 1'b1) detector[k] = 1'b0;
                else if (in[i] == 1'b0 && in[j] == 1'b1 && in[k] == 1'b0) detector[k] = 1'b0;
                else if (in[i] == 1'b0 && in[j] == 1'b1 && in[k] == 1'b1) detector[k] = 1'b0;
                else if (in[i] == 1'b1 && in[j] == 1'b0 && in[k] == 1'b0) detector[k] = 1'b0;
                else if (in[i] == 1'b1 && in[j] == 1'b0 && in[k] == 1'b1) detector[k] = 1'b1;
                else if (in[i] == 1'b1 && in[j] == 1'b1 && in[k] == 1'b0) detector[k] = 1'b0;
                else begin
                    for (b = k; b < N; b = b + 1) detector[b] = 1'b1;
                    flag = 1;
                end
                i = i + 1;
                j = j + 1;
            end
        end
    endfunction
    
    initial begin
        // Initialization
        clk = 1'b0;
        inH = 1'b0;
        rst = 1'b0;
        counter = 0;
        error = 0;

        //sequence = 20'b00010100010100101010;
        sequence = 20'b00010101110100101010;

        // Make out the output of the sequence detector if N is greater than 2.
        // Be aware that the output of the detector function is from MSB to LSB right to left
        if (N > 2) out = detector(sequence);
        else if (N == 2) out = {2{1'b0}};
        else out = 1'b0;

        // Test if the hardware and software detectors get the same result
        $display("Test Begins");
        #2 inH = sequence[0];
        #0;
        if (outH != out[0]) begin
            $display("Error Input %d: Correct Output=%b, Output=%b", counter + 1, out[0], outH);
            error = error + 1;
        end
        for (counter = 1; counter < N; counter = counter + 1) begin
            #10
            inH = sequence[counter];
            //@(posedge clk);
            #0;
            if (outH != out[counter]) begin
                $display("Error Input %d: Correct Output=%b, Output=%b", counter + 1, out[counter], outH);
                error = error + 1;
            end
        end
        $display("Test Ends");
        $display("Number of Error: %d", error);
    end
    always@(clk) #5 clk <= ~clk;
endmodule