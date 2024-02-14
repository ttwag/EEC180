module tb_multControl;
    reg clk, Resetn, Start;
    reg signed [7:0] Mplier, Mcand;
    wire [17:0] Product;
    wire Done;

    multControl multiplier(.Start(Start), .clk(clk), .Resetn(Resetn), .Mplier(Mplier), .Mcand(Mcand), .Done(Done), .Product(Product));

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        Resetn = 1'b0;
        Start = 1'b0;
        Mplier = 8'b00000000;
        Mcand = 8'b00000000;
        
        #1 Resetn = 1'b1;
        #1 Resetn = 1'b0;

        #2 Start = 1'b1;

    end
endmodule