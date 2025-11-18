
`timescale 1ns / 1ps
`default_nettype none 

module clocken
#(parameter DIVISOR = 50000)
(
  input wire sysclk,
  input wire reset,
  output reg slow_clock, 
  output reg slow_rise, // rising slowclk
  output reg slow_fall // falling slowclk
);


// Input is a fast system clock (eg 100MHz) and a DIVISOR 
// parameter. 
// Output is a slow clock (eg 1 kHz) with a frequency 
//    (1/DIVISOR) * sysclk
// Output slow_rise is a pulse, 1 clock cycle in length, marking
// the rising edge of slow_clock. 
// Output slow_fall is a pulse, 1 clock cycle in length,
// marking the falling edge of slow_clock.

localparam COUNTER_BITS = $clog2(DIVISOR);
reg [COUNTER_BITS - 1 : 0] count;


always @(posedge sysclk) begin
  if (reset) begin
     count = 0;
  end else if (count == DIVISOR-1) begin
     count <= 0;
     slow_clock <= 1;
     slow_rise <= 1;
  end else if (count == (DIVISOR/2)-1) begin
     count <= count+1;
     slow_clock <= 0; 
     slow_fall <= 1;
  end else begin
     count <= count+1;
     slow_rise <= 0;
     slow_fall <= 0;
  end
end

endmodule
