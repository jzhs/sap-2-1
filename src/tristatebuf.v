
`timescale 1ns/1ps
`default_nettype none 

module tristate_buffer
  #(parameter size = 8)
   (
    input wire en,
    input wire [size-1:0] in,
    input wire [size-1:0] bus
   );

   assign bus =  en ? in : {size{1'bz}};
 
endmodule
