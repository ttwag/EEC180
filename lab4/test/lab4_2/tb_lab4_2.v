module lab4_2;
    // N is the bit length of the sequence
    parameter N = 20;
    reg [N-1:0]sequence;
    reg [N-1:0]out;

    // The detector function returns the output of the sequence detector
    function [N-1:0] detector(input [N-1:0]in);
        integer i, j, k, b;
        integer m;
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
        sequence = 20'b11110100010100101010;

        // Make out the output of the sequence detector if N is greater than 2.
        // Be aware that the output of the detector function is from MSB to LSB right to left
        if (N > 2) out = detector(sequence);
        else if (N == 2) out = {2{1'b0}};
        else out = 1'b0;
        $display("%b", out);
    end
    
endmodule