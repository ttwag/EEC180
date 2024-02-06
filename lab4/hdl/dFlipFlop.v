// A module that describes the D-Flip Flop
module dFlipFlop (D, clk, reset, Q);
    input D, clk, reset;
    output reg Q = 1'b0;
    
    always@(posedge clk or negedge reset) begin
        if (~reset) Q <= 0;
        else Q <= D;
    end
endmodule