`timescale 1ns / 1ps
`default_nettype none


module tb_debounce;


   reg sysclk;
   reg reset;
   wire	slow_clock;
   wire	slow_rise;
   wire	slow_fall;  // out-of-phase clock enable


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



   reg	      sig;
   wire	      sigout;
   wire	      sigfall;
   wire	      sigrise;
   
   debouncer UUT
   (
    .clock(sysclk), 
    .clken(slow_clock),
    .reset(reset),
    .in(sig), // noisy input
    .out(sigout), // debounced and synched output
    .out_rise(sigrise),
    .out_fall(sigfall)
    );
   


   initial begin
      sysclk = 0;
      reset = 1;
      #4;
      reset = 0;
      
      #20;
      sig = 1;
      #200.4;
      sig = 0;
      #200;
      $finish;
      
   end
endmodule
