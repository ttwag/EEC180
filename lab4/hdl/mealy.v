module mealy (
  input clk, rst_n, x,
  output reg z
);

  parameter A = 3'b001;
  parameter B = 3'b010;
  parameter C = 3'b011;
  parameter D = 3'b100;
  parameter E = 3'b101;
  parameter F = 3'b110;
  parameter G = 3'b111;
  parameter H = 3'b000;
  
  reg [2:0] state, ns;

  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      state <= A;
    end
    else begin
      state <= ns;
    end
  end

  always @(state or x) begin
    case (state)
	A: begin
      if (x == 1'b0) begin
                ns = F; // if 0 goes to F (0)
                z = 1'b0;
            end 
            else begin 
                ns = B; // else B (1)
                z = 1'b0;
            end
    end

    B: begin
      if (x ==1'b0) begin
        ns = C; // if 0 goes to C (10)
        z = 1'b0;
      end 
      else begin
        ns = D; // else D (11)
        z = 1'b0;
      end
    end

    C: begin
      if (x == 1'b0) begin
        ns = F; // if 0 goes to F
        z = 1'b0;
      end
      else begin
        ns = H; // else H
        z = 1'b1;
      end
    end

    D: begin
      if (x == 1'b0) begin
        ns = C; // if 0 goes to C 
        z = 1'b0;
      end
      else begin
        ns = E; // else E
        z = 1'b1;
      end
    end

    E: begin
            ns = E; // Forever stay in state E
        end

    F: begin
      if (x == 1'b0) begin
        ns = G; // if 0 goes to G 
        z = 1'b0;
      end
      else begin
        ns = H; // else H
        z = 1'b0;
      end
    end

    G: begin
      if (x == 1'b0) begin
        ns = E; // if 0 goes to E
        z = 1'b0;
      end
      else begin
        ns = H; // else H
        z = 1'b0;
      end
    end

    H: begin
  	  if (x == 1'b0) begin
        ns = C; // if 0 goes to C
        z = 1'b0;
      end
      else begin
        ns = D; // else D
        z = 1'b0;
      end
    end     
      default: ns = A;
    endcase
  end

endmodule