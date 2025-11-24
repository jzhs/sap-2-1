
`timescale 1ns / 1ps
`default_nettype none 

module sap2(
	    input wire sysclk,
	    input wire reset,
	    input wire clken
);

   wire [15:0]	       bus;

   // Control signals
   wire		       pc_ld;
   wire		       pc_en;
   wire		       pc_incr;
   

   
   counter #(.size(16))
   pc (
       .sysclk(sysclk),
       .reset(reset),
       .clken(clken),
       .load(pc_ld),
       .wr_en(pc_en),
       .bus(bus)
   );


   

   
   



endmodule
