module controllerIII(
    input ready, clk, 
    input rst,
    input [6:0] dim,
    input [13:0] hist_in0, hist_in1, hist_in2, hist_in3,
    output reg WE_hist, start,
    output reg [13:0] addr_pix,
    output reg [5:0] addr_hist,
    output reg [31:0] dataout_hist,
    // For hist_ module
    output reg rst_hist_, en_hist_
); 

localparam reset = 3'b0;
localparam read_pix_first = 3'b1;
localparam read_pix = 3'b10;
localparam read_hist = 3'b11;
localparam write = 3'b100;

reg [2:0] state = reset;
reg [2:0] ns;
reg [13:0] addr_pix_r;
reg [5:0] addr_hist_r;
reg first_read_hist;

always@(posedge clk, negedge rst) begin
    if (!rst) state <= reset;
    else begin
        state <= ns;
        addr_pix_r <= addr_pix;
        addr_hist_r <= addr_hist;
    end 
end

always@(*) begin
    case(state)
        reset:begin
            WE_hist = 1'b0;
            start = 1'b0;
            addr_pix = 14'b0;
            addr_hist = 6'b0;
            dataout_hist = 32'b0;
            rst_hist_ = 1'b1;
            en_hist_ = 1'b0;
            first_read_hist = 1'b0;
            if (ready) begin
                rst_hist_ = 1'b1;
                ns = read_pix_first;
            end
            else begin
                rst_hist_ = 1'b0;
                ns = reset;
            end
        end
        read_pix_first:begin
            WE_hist = 1'b0;
            start = 1'b0;
            dataout_hist = 32'b0;
            rst_hist_ = 1'b1;
            first_read_hist = 1'b0;
            en_hist_ = 1'b1;
            addr_pix = addr_pix_r + 1;
            addr_hist = 6'b0;
            ns = read_pix;
        end
        read_pix:begin
            WE_hist = 1'b0;
            start = 1'b0;
            dataout_hist = 32'b0;
            rst_hist_ = 1'b1;
            first_read_hist = 1'b0;
            en_hist_ = 1'b1;
            addr_pix = addr_pix_r + 1;
            addr_hist = 6'b0;
            if (addr_pix == ({7'b0, dim}**2) >> 2) begin
                addr_pix = 6'b0;
                first_read_hist = 1'b1;
                ns = read_hist;
            end
            else begin
                ns = read_pix;
            end
        end
        read_hist:begin
            WE_hist = 1'b0;
            start = 1'b0;
            addr_pix = 14'b0;
            if (first_read_hist == 1'b1) begin
                addr_hist = addr_hist_r;
                first_read_hist = 1'b1;
            end
            else begin
                addr_hist = addr_hist_r + 6'b1;
                first_read_hist = 1'b0;
            end
            dataout_hist = 32'b0;
            rst_hist_ = 1'b1;
            en_hist_ = 1'b0;
            ns = write;
        end
        write:begin
            WE_hist = 1'b1;
            start = 1'b0;
            addr_pix = 14'b0;
            addr_hist = addr_hist_r;
            dataout_hist = hist_in0 + hist_in1 + hist_in2 + hist_in3;
            rst_hist_ = 1'b1;
            en_hist_ = 1'b0;
            first_read_hist = 1'b0;
            if (addr_hist == 6'b111) begin
                start = 1'b1;
                ns = reset;
            end
            else begin
                ns = read_hist;
            end
        end
    endcase
end


endmodule