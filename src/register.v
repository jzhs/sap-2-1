`timescale 1ns/1ps
`default_nettype none 

module register
#(parameter size = 8, ival = 0)
(
  input wire sysclk,
  input wire reset,
  input wire clken,
  input wire load,
  input  wire [size-1:0] data_in,
  output reg [size-1:0] value
);

always @(posedge sysclk or posedge reset)
begin
   if (reset) begin
      value <= ival;
   end else if (clken) begin
      if (load)
	value <= data_in;
      else
	value <= value;
   end
end

endmodule
