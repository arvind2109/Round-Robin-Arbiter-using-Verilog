module arbiter_TB;
  // Inputs
  reg clk;
  reg cyc3;
  reg cyc2;
  reg cyc1;
  reg cyc0;
  reg rst;

  //outputs
  wire comcyc;
  wire [1:0] gnt;
  wire gnt3;
  wire gnt2;
  wire gnt1;
  wire gnt0;

// Instantiate the UUT
  arbiter uut (.clk(clk), .comcyc(comcyc), .cyc(cyc3), .cyc2(cyc2), .cyc1(cyc1), .cyc0(cyc0), .gnt(gnt), .gnt3(gnt3), .gnt2(gnt2), .gnt1(gnt1), .gnt0(gnt0), .rst(rst));

  parameter clk_period = 20;
  initial
    begin
      cyc3 = 0; cyc2 = 0; cyc 1 =0; cyc0 = 0; rst = 1;#30;
      cyc3 = 0; cyc2 = 0; cyc 1 =0; cyc0 = 1; rst = 0;#30;
      cyc3 = 0; cyc2 = 1; cyc 1 =1; cyc0 = 0;#30;
      cyc3 = 1; cyc2 = 0; cyc 1 =0; cyc0 = 0;#30;
    end
  initial
    begin
      clk=0;
      forever #(clk_period/2) clk = ~clk;
    end
endmodule
