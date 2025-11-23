`timescale 1ns / 1ps
`default_nettype none

module tb_register;

   reg sysclk;
   reg reset;
   wire	slow_clock;
   wire	slow_rise;
   wire	slow_fall;  // out-of-phase clock enable


   
   reg A_ld, A_wr;
   reg B_ld, B_wr;
   
   
   wire [7:0] bus;


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


   
   tristate_register #(.size(8), .ival(8'b10101010))
   A (.sysclk(sysclk),
      .reset(reset),
      .clken(slow_rise),
      .load(A_ld),
      .wr_en(A_wr),
      .bus(bus)    
      );


   tristate_register #(.size(8), .ival(8'b01010101))
   B (.sysclk(sysclk),
      .reset(reset),
      .clken(slow_rise),
      .load(B_ld),
      .wr_en(B_wr),
      .bus(bus)
      );


   initial begin
      sysclk = 0;
      reset = 0;
      
      #4;
      reset = 1;
      #4;
      reset = 0;
      #4;
      A_wr = 1;
      B_wr = 0;
      #20;
      A_wr = 0;
      #10;
      B_wr = 1;
      #10;
      A_ld = 1;
      #4;
      A_ld = 0;
      B_wr = 0;
      #80;
      $finish;
      
   end
endmodule
