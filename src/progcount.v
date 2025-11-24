
`timescale 1ns / 1ps
`default_nettype none 

module program_counter #(parameter SIZE = 16)(
	    input wire sysclk,
	    input wire reset,
	    input wire clken,
	    input wire load,
	    input wire incr,
	    input wire wr_en,
	    inout wire [SIZE-1:0] bus 
);


   wire [SIZE-1:0]	       value;
   
   counter #(.size(SIZE))
   regi(
	.sysclk(sysclk),
	.reset(reset),
	.clken(clken),
	.load(load),
	.incr(incr),
	.data_in(bus),
	.value(value)
	);


   assign bus =  wr_en ? value : {SIZE{1'bz}};
    
endmodule
