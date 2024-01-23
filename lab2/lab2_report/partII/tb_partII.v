module testbench;
    reg [8:0] test;
    reg [7:0] testProduct;
    integer errorCount = 0;
    wire [7:0] product;
    myMultiplier mymodule (.a(test[7:4]), .b(test[3:0]), .product(product[7:0]));
    
    initial begin
        $display("Test Begins:"); 
        for (test = 0; test < 2**8; test = test + 1) begin
            testProduct = test[7:4] * test[3:0];
            #5;
            if (product[7:0] != testProduct) begin 
                $display("ERROR: A = %b, B = %b, Product = %b != %b", test[7:4], test[3:0], testProduct, product[7:0]);
                errorCount = errorCount + 1;
            end
        end
        $display("Conducted %d Tests\n", test);
        $display("%d Error", errorCount);
    end
endmodule