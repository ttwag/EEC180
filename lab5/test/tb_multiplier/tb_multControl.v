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
        Mplier = 8'b11111111;
        Mcand = 8'b11111111;
        
        #1 Resetn = 1'b1;
        #1 Resetn = 1'b0;

        #2 Start = 1'b1;
    end

    always@(Product) begin
        if (Done) $display("Final Product = %b", Product[17:1]);
        else $display("Current Product = %b", Product[17:0]);
    end

endmodule