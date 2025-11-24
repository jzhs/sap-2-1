
`timescale 1ns / 1ps
`default_nettype none 

module tb_pc;
   reg         sysclk;
   reg	       reset;
   
   wire	       slow_clock;
   wire	       slow_rise;
   wire	       slow_fall;  // out-of-phase clock enable



   reg	       incr;
   reg	       pc_en;
   reg	       pc_ld;
   reg	       pc_incr;
   
	       
   wire [15:0] value;
   


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


   always #1 sysclk = ~sysclk;


   wire [15:0] bus;

   
   program_counter
     pc (
	 .sysclk(sysclk),
	 .reset(reset),
	 .clken(slow_rise),
	 .load(pc_ld),
	 .incr(pc_incr),
	 .wr_en(pc_en),
	 .bus(bus)
	 );
   
   wire	  [15:0]     X = pc.regi.value;
   
   
   initial begin
      sysclk = 0;
      pc_ld = 0;
      pc_en = 0;
      pc_incr = 0;
      
      reset = 1;
      #2;
      reset = 0;
      #16;
      pc_en = 1;
      #30;
      pc_en = 0;
      #10;
      pc_incr = 1;
      #10;
      pc_en = 1;
      
      #100;
      
      $finish;
   end


endmodule
