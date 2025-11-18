// The purpose of this project is to demostrate debouncing.
// Press and release the central pushbutton (btnC).
// The right 8 leds will count the number of signal changes and
// the left 8 leds count the number of changes on the
// debounced signal. The left count will increment once for each
// press and once for each release. The right count will be more
// erratic.


module debounce_top
  (
   input wire	      CLOCK_100MHZ,
   input wire	      btnC,
   
   input wire [15:0]  SW,
   output wire [15:0] LED
   );


   wire		      clock_1khz;
   wire		      clock_1khz_rise;
   wire		      clock_1khz_fall;
   

   reg [7:0]	      cnt;
   reg		      prev;

   reg [7:0]	      cnt_clean;
   reg		      prev_clean;

   wire		      btnC_clean;
  
 
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
   
   
   always @(posedge CLOCK_100MHZ)
     if (btnC != prev) begin
	prev <= btnC;
	cnt <= cnt+1;
     end
   
   
   always @(posedge CLOCK_100MHZ)
     if (btnC_clean != prev_clean) begin
	prev_clean <= btnC_clean;
	cnt_clean <= cnt_clean+1;
     end
   
		    
   assign LED[7:0] = cnt;
   assign LED[15:8] = cnt_clean;
   

endmodule

   
