module tb_seqDetector #(parameter N = 3) (
    input [N-1:0] inSequence,
    output reg [N-1:0] out 
);

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
            end
        end
    endfunction

    initial begin
        // if (N >= 3) out = detector(inSequence);
        // else out = {N{1'b0}};
        out = {N{1'b0}};
    end
endmodule