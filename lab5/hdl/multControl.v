module multControl (
    input Start, clk, Resetn,
    input [7:0] Mplier, Mcand,
    output Done,
    output reg signed [17:0] Product
);

    // State Initialization
    reg [1:0] state;
    reg [1:0] nextState;
    reg [2:0] count;

    localparam S1 = 2'b00;
    localparam S2 = 2'b01;
    localparam S3 = 2'b10;
    
    // Data Initialization
    reg signed [7:0] C, CompC;
    reg signed [17:0] lastProduct;

    // State Transition
    always@(posedge clk or posedge Resetn) begin
        if (Resetn) state <= S1;
        else begin
            case(state)

            endcase
            state <= nextState;

        end 
    end
    
    assign Done = count[2] && count[1] && count[0];

    // State Transition Logic
    always@(*) begin
        case(state)
            S1:begin
                if (!Start) nextState = S1;
                else begin
                    nextState = S2;
                    Product = {9'b000000000, Mplier, 1'b0};
                    C = {Mcand, 9'b000000000};
                    CompC = {(~Mcand) + 8'b00000001, 9'b000000000};
                    count = 3'b000;
                end
            end
            S2:begin
                if (~Done & ~(Product[1]^Product[0])) begin
                    // Stay in S2;
                    Product <= Product >>> 1;
                    count <= count + 1;
                    nextState = S2;
                end
                else if (Done & ~(Product[1]^Product[0])) begin
                    // Go to S1
                    Product <= Product >>> 1;
                    nextState = S1;
                end
                else begin
                    // Go to S3
                    if (Product[1]) Product <= Product + CompC;
                    else Product <= Product + C;
                    nextState = S3;
                end
            end
            S3:begin
                if (!Done) begin
                    // Go to S2
                    Product <= Product >>> 1;
                    //count <= count + 1;
                    nextState = S2;
                end
                else begin
                    // Go to S1
                    Product <= Product >>> 1;
                    nextState = S1;
                end
            end
        endcase
    end
endmodule