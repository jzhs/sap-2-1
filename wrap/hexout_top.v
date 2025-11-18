// Similar to the debounce_top project except that output
// is attached to the basys3 4-digit seven segment display.
// Left button (btnL) is attached to a reset seignal.

module hexout_top(
    input wire	       CLOCK_100MHZ, 
    input wire [15:8]  SW, // the sixteen (now 8) switches
    output wire [15:0] LED,
    input wire	       btnC, // attach to counter
    input wire	       btnL, // Reset
    output wire [6:0]  SEG, 
    output wire [3:0]  AN  
    //output wire DP,      // Decimal Point, unused
);


   wire		       reset;
   wire		       clock_1khz;
   wire		       clock_1khz_rise;
   wire		       clock_1khz_fall;

   wire		       btnC_clean;
   reg [7:0]	       cnt;
   reg		       prev;
   reg [7:0]	       cnt_clean;
   reg		       prev_clean;
   
   clocken #(.DIVISOR(100000))
   clockenable1
   (
    .sysclk(CLOCK_100MHZ),
    .slow_clock(clock_1khz),
    .slow_rise(clock_1khz_rise),
    .slow_fall(clock_1khz_fall)
   );

   
   debouncer BTNC_DEB
   (
    .clock(CLOCK_100MHZ),
    .clken(clock_1khz_rise),
    .in(btnC),
    .out(btnC_clean) 
   );

   debouncer BTNL_DEB
   (
    .clock(CLOCK_100MHZ),
    .clken(clock_1khz_rise),
    .in(btnL),
    .out(reset) 
   );
   

   hexout_4_digits hex_display
   (
    .clk(CLOCK_100MHZ),
    .clken(clock_1khz_rise),
    .reset(reset),
    .word({cnt_clean, cnt}),
    .seg(SEG),
    .an(AN)
   );
   
   
   always @(posedge CLOCK_100MHZ)
     if (reset) begin
	prev <= 0;
	cnt <= 0;
     end else if (btnC != prev) begin
	prev <= btnC;
	cnt <= cnt+1;
     end
   
   
   always @(posedge CLOCK_100MHZ)
     if (reset) begin
	prev_clean <= 0;
	cnt_clean <= 0;
     end else if (btnC_clean != prev_clean) begin
	prev_clean <= btnC_clean;
	cnt_clean <= cnt_clean+1;
     end
   

   
   
endmodule
