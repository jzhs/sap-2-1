
// Project to put clocken on basys3.
// I think I'll need clock enable signals of frequencies
// 1 MHz for the cpu main clock, and 1 KHz for the debouncers.

// Here I'll generate these signals and test by slowing them down
// to see if I get a 1 Hz signal.

module clock_top(
	   input wire CLOCK_100MHZ,
	   input wire btnC,
	   output wire [15:0] LED
);

   
   localparam	       CLKDIV = 100_000_000;


   wire		       reset;
   
   
   wire		       clock_1khz_rise;
   wire		       clock_1khz_fall;
   wire		       clock_1khz;

   
   wire		       clock_1mhz_rise;
   wire		       clock_1mhz_fall;
   wire		       clock_1mhz;

   
   assign reset = btnC;
   
   
   // Divide by 100 to get a 1 MHz clock
   
   clocken #(.DIVISOR(100)) 
   clocken1(
	    .sysclk(CLOCK_100MHZ), 
	    .reset(reset),
	    .slow_clock(clock_1mhz),
	    .slow_rise(clock_1mhz_rise), 
	    .slow_fall(clock_1mhz_fall)
	    );


   // Divide by 100000 to get a 1 KHz clock
   clocken #(.DIVISOR(100000)) 
   clocken2(
	    .sysclk(CLOCK_100MHZ), 
	    .reset(reset),
	    .slow_clock(clock_1khz),
	    .slow_rise(clock_1khz_rise), 
	    .slow_fall(clock_1khz_fall)
	    );

   reg [9:0]	       count;
   reg		       slowc;
   
   always @(posedge clock_1khz)
     if (count == 1000 - 1) begin
	count <= 0;
	slowc <= 0;
     end else if (count == 500 - 1) begin
	slowc <= 1;
	count <= count + 1;
     end else begin
	count <= count + 1;
     end
   
	
   assign LED[15] = 1'b1;
   assign LED[14] = CLOCK_100MHZ;
   assign LED[0]  = slowc;

   
   
endmodule
