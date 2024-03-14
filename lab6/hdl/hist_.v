module hist_(
    input [7:0] datain,
    input [5:0] addr,
    input en, rst, clk,
    output reg [13:0] hist_out // Array of 8 bins, each has 14 bit value
);
    reg [13:0] hist_outROM [7:0];
    always@(posedge clk) begin
        hist_out <= hist_outROM[addr]; 
    end

    //reg [13:0] bin0, bin1, bin2, bin3, bin4, bin5, bin6, bin7;
    always@(posedge clk, negedge rst) begin
        if (!rst) begin
            // Reset
            hist_outROM[0] <= 14'b0;
            hist_outROM[1] <= 14'b0;
            hist_outROM[2] <= 14'b0;
            hist_outROM[3] <= 14'b0;
            hist_outROM[4] <= 14'b0;
            hist_outROM[5] <= 14'b0;
            hist_outROM[6] <= 14'b0;
            hist_outROM[7] <= 14'b0;
        end
        else if (en) begin
            // 0 <= datain < 32
            if (datain >= 8'b00000000 && datain < 8'b100000) hist_outROM[0] <= hist_outROM[0] + 14'b1;
            // 32 <= datain < 64
            else if (datain >= 8'b100000 && datain < 8'b1000000) hist_outROM[1] <= hist_outROM[1] + 14'b1;
            // 64 <= datain < 96
            else if (datain >= 8'b1000000 && datain < 8'b1100000) hist_outROM[2] <= hist_outROM[2] + 14'b1;
            // 96 <= datain < 128
            else if (datain >= 8'b1100000 && datain < 8'b10000000) hist_outROM[3] <= hist_outROM[3] + 14'b1;
            // 128 <= datain < 160
            else if (datain >= 8'b10000000 && datain < 8'b10100000) hist_outROM[4] <= hist_outROM[4] + 14'b1;
            // 160 <= datain < 192
            else if (datain >= 8'b10100000 && datain < 8'b11000000) hist_outROM[5] <= hist_outROM[5] + 14'b1;
            // 192 <= datain < 224
            else if (datain >= 8'b11000000 && datain < 8'b11100000) hist_outROM[6] <= hist_outROM[6] + 14'b1;
            // 224 <= datain < 256
            else hist_outROM[7] <= hist_outROM[7] + 14'b1;
        end
        else begin
            hist_outROM[0] <= hist_outROM[0];
            hist_outROM[1] <= hist_outROM[1];
            hist_outROM[2] <= hist_outROM[2];
            hist_outROM[3] <= hist_outROM[3];
            hist_outROM[4] <= hist_outROM[4];
            hist_outROM[5] <= hist_outROM[5];
            hist_outROM[6] <= hist_outROM[6];
            hist_outROM[7] <= hist_outROM[7];
        end
    end

endmodule