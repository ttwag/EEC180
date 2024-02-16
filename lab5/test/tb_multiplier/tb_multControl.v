module tb_multControl;
    reg clk, Resetn, Start;
    reg signed [7:0] Mplier, Mcand;
    wire [17:0] Product;
    wire Finish;

    multControl multiplier(.Start(Start), .clk(clk), .Resetn(Resetn), .Mplier(Mplier), .Mcand(Mcand), .Finish(Finish), .Product(Product));

    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    initial begin
        Resetn = 1'b0;
        Start = 1'b0;
        Mplier = 8'b01100110;
        Mcand = 8'b00110011;
        
        #1 Resetn = 1'b1;
        #1 Resetn = 1'b0;

        #2 Start = 1'b1;
        #3 Start = 1'b0;
        $display("Input = %b * %b", Mplier, Mcand);
    end

    always@(Product) begin
        if (Finish) $display("Final Product = %b", Product[16:1]);
        else $display("Product = %b", Product[17:0]);
    end

endmodule