module histogram_computation (
    input [31:0] datain_pix,
    input clk, ready,
    input [8:0] dim,
    output WE_hist,
    output start,
    output [13:0] addr_pix,
    output [5:0] addr_hist,
    output [31:0] dataout_hist // Connect to datain_hist
);

wire en, rst;
wire [13:0] hist_out0, hist_out1, hist_out2, hist_out3;
wire [7:0] pix0, pix1, pix2, pix3;

assign pix0 = datain_pix[7:0];
assign pix1 = datain_pix[15:8];
assign pix2 = datain_pix[23:16];
assign pix3 = datain_pix[31:24];

controllerIII controller (
    // Input
    .ready(ready),
    .clk(clk),
    .rst(rst),
    .dim(dim),
    .hist_in0(hist_out0),
    .hist_in1(hist_out1),
    .hist_in2(hist_out2),
    .hist_in3(hist_out3),
    // Output
    .WE_hist(WE_hist),
    .start(start),
    .addr_pix(addr_pix),
    .addr_hist(addr_hist),
    .dataout_hist(dataout_hist),
    .rst_hist_(rst),
    .en_hist_(en)
);

hist_ hist0(
    .datain(pix0),
    .addr(addr_hist),
    .en(en),
    .rst(rst),
    .clk(clk),
    .hist_out(hist_out0)
);

hist_ hist1(
    .datain(pix1),
    .addr(addr_hist),
    .en(en),
    .rst(rst),
    .clk(clk),
    .hist_out(hist_out1)
);

hist_ hist2(
    .datain(pix2),
    .addr(addr_hist),
    .en(en),
    .rst(rst),
    .clk(clk),
    .hist_out(hist_out2)
);
hist_ hist3(
    .datain(pix3),
    .addr(addr_hist),
    .en(en),
    .rst(rst),
    .clk(clk),
    .hist_out(hist_out3)
);


endmodule