module tb_lab4;
    reg in, clk, rst;
    wire out;
    seqDetector lab4(.in(in), .clk(clk), .rst(rst), .out(out));

    initial begin
        in = 1'b0;
        clk = 1'b0;
        rst = 1'b0;
        #2 in = 1'b0;
        #10 in = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b0;
        #10 in = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b0;
        #10 in = 1'b0;
        #10 in = 1'b1;
        #10 in = 1'b0;
        #10 in = 1'b1;
        #10 in = 1'b1;
        #10 in = 1'b1;
        #10 in = 1'b1;
    end
    always@(clk) #5 clk <= ~clk;
endmodule