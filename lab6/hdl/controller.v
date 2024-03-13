// Works with RAM size of 28x28

module controller (
    input ready, clk, rst_n,
    input [8:0] dim,
    input [7:0] dataout,
    output reg [7:0] datain,
    output reg [15:0] addr,
    output reg start, writeEnable
);

localparam Sidle = 2'b00;
localparam Sread = 2'b01;
localparam Swrite = 2'b10;

reg [1:0] state, nextState;
reg [15:0] addr_r;
reg start_r;

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= Sidle;
        start <= 1'b0;
    end
    else begin 
        state <= nextState;
        addr_r <= addr;
        start_r <= start; //start <= start_r;
    end
end

always@(*) begin
    case(state)
        Sidle:begin
            // Reset state
            start = start_r; //start_r = 1'b0;
            addr = 16'b0;
            datain = 8'b0;
            writeEnable = 1'b0;
            nextState = Sidle;
            if (ready == 1'b1 && start != 1'b1) begin
                nextState = Swrite;
            end
        end
        Sread:begin
            // Read Memory State
            start = 1'b0; //start_r = 1'b0;
            addr = addr_r + 16'b1;
            datain = 8'b1;
            writeEnable = 1'b0;
            nextState = Swrite;
        end

        Swrite:begin
            // Write Back State
            start = 1'b0; //start_r = 1'b0;
            addr = addr_r;
            datain = dataout;
            writeEnable = 1'b1;
            if (addr >= (dim * dim - 1)) begin 
                start = 1'b1; //start_r = 1'b1;
                nextState = Sidle;
            end
            else begin
                nextState = Sread;
            end
        end
    endcase
end

endmodule