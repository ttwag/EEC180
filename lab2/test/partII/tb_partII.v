module testbench ();
    reg test[8:0];
    reg errorCount = 0;
    wire product[7:0];
    mult mymodule (.a(test[7:4]), .b(test[3:0]), .product(product[7:0]));
    
    initial begin 
        for (test = 0; test < 2**8; test = test + 1) begin
            #5;
            if (product[7:0] != test[7:4] * test[3:0]) begin 
                $display("ERROR: A = %d, B = %d, Product = %d != %d", test[7:4], test[3:0], product[7:0], test[7:0] * test[3:0]);
                errorCount = errorCount + 1;
            end
        end

        $display("Conducted %d Tests", test[8:0]);
        $display("%d Error", errorCount);
    end
endmodule