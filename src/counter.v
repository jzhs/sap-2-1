
`timescale 1ns / 1ps
`default_nettype none 

module counter
  #(parameter size=16)
(
	    input wire		   sysclk,
	    input wire		   reset,
	    input wire		   clken,
	    input wire		   load,
	    input wire		   incr,
	    input wire [size-1:0]  data_in,
	    output wire [size-1:0] value
);


   
   wire [size-1:0]     val_p_one;
   assign val_p_one = value + 1;
   
   
   register #(.size(16))
   regi(
	.sysclk(sysclk),
	.reset(reset),
	.clken(clken),
	.load(incr | load),
	.data_in(incr ? val_p_one : data_in),
	.value(value)     
	);
   
endmodule
