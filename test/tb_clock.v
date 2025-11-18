`timescale 1ns / 1ps
`default_nettype none

module tb_clock;

reg sysclk;
reg reset;
wire slow_clock;
wire slow_rise;
wire slow_fall;  // out-of-phase clock enable


localparam CLKLEN = 8;

always #1 sysclk <= ~sysclk;

clocken #(.DIVISOR(CLKLEN)) 
clocken1(
   .sysclk(sysclk), 
   .reset(reset),
   .slow_clock(slow_clock),
   .slow_rise(slow_rise), 
   .slow_fall(slow_fall)
);



initial begin
  $dumpfile("top_tb.vcd");
  $dumpvars;
  sysclk = 0;
  reset = 1;
  #4;
  reset = 0;
  #100;
  $finish;
end
endmodule
