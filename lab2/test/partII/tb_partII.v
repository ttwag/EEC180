module testbench;
    reg [4:0] test;
    reg [3:0] testProduct;
    integer errorCount = 0;
    wire [3:0] product;
    myMultiplier mymodule (.a(test[3:2]), .b(test[1:0]), .product(product[3:0]));
    
    initial begin
        $display("Test Begins:"); 
        for (test = 0; test < 2**4; test = test + 1) begin
            testProduct = test[3:2] * test[1:0];
            #5;
            if (product[3:0] == testProduct) begin 
                $display("ERROR: A = %b, B = %b, Product = %b != %b", test[3:2], test[1:0], testProduct, product[3:0]);
                errorCount = errorCount + 1;
            end
        end
        $display("Conducted %d Tests\n", test);
        $display("%d Error", errorCount);
    end
endmodule