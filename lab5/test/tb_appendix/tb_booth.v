module tb_booth;
    parameter n=8; // n-bit Booth multiplier
    parameter num_vectors=8;
    reg Clock, Resetn, Start;
    wire Finish;
    reg [n-1:0] Mplier, Mcand;
    wire [n+n-1:0] Product;
    reg [n+n-1:0] vectors [0:num_vectors-1];
    integer i;
    boothMult UUT (.clk(Clock), .Resetn(Resetn), .Start(Start), .Mplier(Mplier), .Mcand(Mcand), .Finish(Finish), .FProduct(Product));

    initial begin
        Clock = 1'b0;
        forever #20 Clock = ~Clock; // Clock period = 40 ns
    end
    initial begin
        Resetn = 1'b1; // synchronous reset of state machine
        Start = 1'b0; // set Start to ‘false’
        #80 Resetn = 1'b0; // reset low for 2 Clock periods
        $readmemb ("testvecs", vectors); // read testvecs file
        for (i=0; i<num_vectors; i=i+1) begin
            {Mplier, Mcand} = vectors[i]; // load Mplier, Mcand
            #20 Start = 1'b1; // Start = ‘true’
            #80 Start = 1'b0; // After 2 clock cycles, reset Start
            wait (Finish==1);
            //wait (Finish==0);
            $display("Mplier=%h, Mcand=%h, Product=%h",Mplier,Mcand,Product);
        end
    end
endmodule
