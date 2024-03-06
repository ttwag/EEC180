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
//reg [8:0] dim_x, dim_y, dim_x_r, dim_y_r;
reg [15:0] addr_r;
reg start_r;

always@(posedge clk or negedge rst_n) begin
    if (!rst_n) state <= Sidle;
    else begin 
        state <= nextState;
        addr_r <= addr;
        //dim_x_r <= dim_x;
        //dim_y_r <= dim_y;
        start <= start_r;
    end
end

always@(*) begin
    case(state)
        Sidle:begin
            // Reset state
            start_r = 1'b0;
            addr = 16'b0;
            datain = 8'b0;
            writeEnable = 1'b0;
            //dim_x = 9'b1;
            //dim_y = 9'b1;
            nextState = Sidle;
            if (ready == 1'b1 && start != 1'b1) begin
                nextState = Swrite;
            end
        end
        Sread:begin
            // Read Memory State
            start_r = 1'b0;
            addr = addr_r + 16'b1;
            datain = 8'b1;
            writeEnable = 1'b0;
            // dim_x = dim_x_r;
            // dim_y = dim_y_r;
            nextState = Swrite;
        end

        Swrite:begin
            // Write Back State
            start_r = 1'b0;
            addr = addr_r;
            datain = dataout;
            writeEnable = 1'b1;
            if (addr >= (dim * dim - 1)) begin 
                start_r = 1'b1;
                nextState = Sidle;
            end
            else begin
                nextState = Sread;
            end
            // if ((dim_x >= (dim - 9'b1)) && (dim_y >= (dim - 9'b1))) begin
            //     // Go back to Sidle when finished
            //     start_r = 1'b1;
            //     dim_x = 9'b0;
            //     dim_y = 9'b0;
            //     nextState = Sidle;
            // end
            // else if (dim_x >= (dim - 9'b1)) begin
            //     // We are at the bottom of the row. 
            //     // Go back Sread and to the next column
            //     dim_x = 9'b1;
            //     dim_y = dim_y_r + 9'b1;
            //     nextState = Sread;
            // end
            // else begin
            //     // We are NOT at the bottom of the row.
            //     // Go back to Sread stay at the same column
            //     dim_x = dim_x_r + 9'b1;
            //     dim_y = dim_y_r;
            //     nextState = Sread;
            // end
        end
    endcase
end

endmodule