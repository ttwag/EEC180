module seqDetector(
    input clk,
    input rst,
    input in,
    output reg out = 1'b0
);


// State Declaration
localparam S0 = 3'b100;
localparam S1 = 3'b110;
localparam S2 = 3'b101;
localparam S3 = 3'b000;
localparam S4 = 3'b001;
localparam S5 = 3'b010;
localparam S6 = 3'b011;
localparam S7 = 3'b111;

reg [2:0] state = S0;
reg [2:0] nextState;

// State Transition
always @(posedge clk or posedge rst) begin
  if (rst) begin
    state <= S0;
  end
  else begin
    state <= nextState;
  end
end

// State Transition
always @(state, in) begin
    case(state)
        S0:begin
          if (in == 1'b0) begin
              nextState = S1; 
              out = 1'b0;
          end 
          else begin
              nextState = S2; 
              out = 1'b0;
          end
        end
        S1:begin
          if (in == 1'b0) begin
                nextState = S3; 
                out = 1'b0;
            end 
            else begin
                nextState = S4; 
                out = 1'b0;
            end
        end
        S2:begin
          if (in == 1'b0) begin
                nextState = S5; 
                out = 1'b0;
            end 
            else begin
                nextState = S6; 
                out = 1'b0;
            end
        end
        S3:begin
          if (in == 1'b0) begin
                nextState = S7; 
                out = 1'b0;
            end 
            else begin
                nextState = S4; 
                out = 1'b0;
            end
        end
        S4:begin
          if (in == 1'b0) begin
                nextState = S5; 
                out = 1'b0;
            end 
            else begin
                nextState = S6; 
                out = 1'b0;
            end
        end
        S5:begin
          if (in == 1'b0) begin
                nextState = S3; 
                out = 1'b0;
            end 
            else begin
                nextState = S4; 
                out = 1'b1;
            end
        end
        S6:begin
          if (in == 1'b0) begin
                nextState = S5; 
                out = 1'b0;
            end 
            else begin
                nextState = S7; 
                out = 1'b1;
            end
        end
        S7:begin
          nextState = S7;
        end
        default:begin
          nextState = S0;
          out = 1'b0;
        end
    endcase
end
endmodule