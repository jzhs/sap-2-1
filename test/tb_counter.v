
`timescale 1ns / 1ps
`default_nettype none 

module tb_counter;

   reg sysclk;
   reg reset;
   wire	clken;
   reg	incr;
   wire [15:0] value;
   

   wire	       slow_clock;
   wire	       slow_rise;
   wire	       slow_fall;  // out-of-phase clock enable



   // sysclk has a period of 2
   // slow_clock will have a period of 16.

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


   counter UUT(
	       .sysclk(sysclk),
	       .reset(reset),
	       .clken(slow_rise),
	       .incr(incr),
	       .value(value)
	       );
   

   initial begin
      sysclk = 0;
      incr = 0;
      reset = 1;
      #2;
      reset = 0;
      #10;
      incr = 1;
      #16;
      incr = 0;
      #40;
      incr = 1;
      #16;
      incr = 0;
      
      #100;
      
      $finish;
      
      
      
   end
endmodule
