// A module that tests the D-Flip Flop
module tb_dFlipFlop;
    reg D, clk, reset;
    wire Q;
    dFlipFlop FP(.D(D), .clk(clk), .reset(reset), .Q(Q));
    initial begin
        D = 1'b0;
        clk = 1'b0;
        reset = 1'b1;
        #5 D = 1'b1;
    end
    always@(clk) #5 clk <= ~clk;
endmodule