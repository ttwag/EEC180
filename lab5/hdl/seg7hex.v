module seg7hex (
    input [3:0] hex,
    output reg[7:0] seg
);
    // decoder displays the hex value of a 4-bit binary number on the HEX display.

    //Update the output based on hex
    always @(hex) begin
        case (hex)
            4'b0000: seg = 8'b11000000;
            4'b0001: seg = 8'b11111001;
            4'b0010: seg = 8'b10100100;
            4'b0011: seg = 8'b10110000;
            4'b0100: seg = 8'b10011001;
            4'b0101: seg = 8'b10010010;
            4'b0110: seg = 8'b10000010;
            4'b0111: seg = 8'b11111000;
            4'b1000: seg = 8'b10000000;
            4'b1001: seg = 8'b10011000;
            4'b1010: seg = 8'b10001000;
            4'b1011: seg = 8'b10000011;
            4'b1100: seg = 8'b11000110;
            4'b1101: seg = 8'b10100001;
            4'b1110: seg = 8'b10000110;
            4'b1111: seg = 8'b10001110;
        endcase
    end

endmodule