module image_processor (
    input [1:0] mode,
    input [7:0] pixel_in,
    output reg [7:0] pixel_out
);

localparam tint = 2'b00;
localparam invert = 2'b01;
localparam threshohold = 2'b10;
localparam increase_contrast = 2'b11;

always@(*) begin
    case(mode)
        tint:begin
            if (pixel_in > 8'b1000000) pixel_out = pixel_in - 8'b1000000;
            else pixel_out = 8'b0;
        end
        invert:begin
            pixel_out = ~pixel_in;
        end
        threshohold:begin
            if (pixel_in > 8'b01111111) pixel_out = 8'b11111111;
            else pixel_out = 8'b0;
        end
        increase_contrast:begin
            if (pixel_in < 8'b1010101) pixel_out = pixel_in >> 1;
            else if (pixel_in < 8'b10101011) pixel_out = (pixel_in << 1) - 8'b10000000;
            else pixel_out = (pixel_in >> 1) + 8'b10000000;
        end
    endcase
end

endmodule