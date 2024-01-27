module tb_multiplier;

  // Inputs
  reg start;
  reg clk;
  reg reset;
  reg [3:0] a;
  reg [3:0] b;

  // Outputs
  wire [((4*2)/3)+1*4-1:0] bcd;
  wire [4*2-1:0] out;
  wire finish;

  // Instantiate the multiplier module
  multiplier uut (
    .out(out),
    .a(a),
    .b(b),
    .clk(clk),
    .start(start),
    .reset(reset),
    .finish(finish),
    .bcd(bcd)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Test scenario
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_multiplier);

    // Test case 1
    start = 0;
    reset = 1;
    a = 4'b1010;
    b = 4'b0011;
    #10 reset = 0;
    #5 start = 1;
    #100 start = 0;

    // Test case 2
    #10 reset = 1;
    #5 reset = 0;
    a = 4'b1100;
    b = 4'b0101;
    #10 start = 1;
    #100 start = 0;

    #20 $finish;
  end

endmodule