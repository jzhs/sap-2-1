
module clock_top(
	   input wire CLOCK_100MHZ,
	   input wire btnC,
	   output wire [15:0] LED
);

   
   localparam	       CLKDIV = 100_000_000;

   assign sysclk = CLOCK_100MHZ;
   assign reset = btnC;
   
   
   clocken #(.DIVISOR(CLKDIV)) 
   clocken1(
	    .sysclk(sysclk), 
	    .reset(reset),
	    .clken(clken), 
	    .clken2(clken2), 
	    .slowclk(slowclk)
	    );

   assign LED[15] = 1'b1;
   assign LED[14] = sysclk;
   assign LED[0]  = slowclk;
   
endmodule
