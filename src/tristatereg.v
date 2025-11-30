
`timescale 1ns/1ps
`default_nettype none 

module tristate_register
#(parameter size = 8, ival = 0)
(
 input wire	       sysclk,
 input wire	       reset,
 input wire	       clken,
 input wire	       load,
 input wire	       wr_en,
 inout wire [size-1:0] bus
);

   wire [size-1:0]     value;
   

   register #(.size(size), .ival(ival))
   r
   ( 
      .sysclk(sysclk),
      .reset(reset),
      .clken(clken),
      .load(load),
      .data_in(bus),
      .value(value) 
   );
   
   //assign bus =  wr_en ? value : {size{1'bz}};
   tristate_buffer #(.size(size))
   (
    .en(wr_en),
    .in(value),
    .bus(bus)
   );
   
endmodule
