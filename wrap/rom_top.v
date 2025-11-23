// Testing the idea of loading a memory from uart
// Hex display addr and last data in


`timescale 1ns / 1ps
`default_nettype none

module rom_top(
       input wire	  CLOCK_100MHZ,
       input wire [15:0]  SW, 
       output wire [15:0] LED,
       input wire	  btnC, // attach to counter
       input wire	  btnL, // Reset
       output wire [6:0]  SEG, 
       output wire [3:0]  AN,
       input wire	  RsRx,
       output wire	  RsTx
);

   wire		       clock_1khz;
   wire		       clock_1khz_rise;
   wire		       clock_1khz_fall;
   wire		       next;
   

   wire		       reset; 
   wire		       reset_rise;
   wire		       reset_fall;
   

   wire		       btnC_clean; 
   wire		       btnC_rise;
   wire		       btnC_fall;
   

   clocken #(.DIVISOR(100000))
   clockenable1
   (
    .sysclk(CLOCK_100MHZ),
    .slow_clock(clock_1khz),
    .slow_rise(clock_1khz_rise),
    .slow_fall(clock_1khz_fall)
   );

   
   debouncer BTNL_DEB
   (
    .clock(CLOCK_100MHZ),
    .clken(clock_1khz_rise),
    .in(btnL),
    .out(reset), // reset is a debounced btnL
    .out_rise(reset_rise),
    .out_fall(reset_fall)
   );
   

   debouncer BTNC_DEB
   (
    .clock(CLOCK_100MHZ),
    .reset(reset),
    .clken(clock_1khz_rise),
    .in(btnC),
    .out(btnC_clean), // debounced & synched
    .out_rise(btnC_rise),
    .out_fall(btnC_fall)    
   );

   assign next = btnC_rise;
   
   reg [9:0]	       addr;
   wire [7:0]	       data;
   wire [7:0]	       data_out;
   reg		       rw;
   

   memory ram (
     .clk(CLOCK_100MHZ),
     .rw(rw),
     .addr(addr),
     .data_in(rx_byte),
     .data_out(data_out)
   );


   wire [7:0]	       rx_byte;
   wire		       rx_dv;
   
   UART_RX #(.CLKS_PER_BIT(10416))
   usbuartrx(
     .i_Rst_L(~reset),
     .i_Clock(CLOCK_100MHZ),
     .i_RX_Serial(RsRx),  // The Basys3 USB-UART rx line
     .o_RX_DV(rx_dv),
     .o_RX_Byte(rx_byte)
    );


   reg		       show;
   
   hexout_4_digits hex_display
   (
    .clk(CLOCK_100MHZ),
    .clken(clock_1khz_rise),
    .reset(reset),
    .word({addr[7:0], show ? data_out : rx_byte}),
    .seg(SEG),
    .an(AN)
   );


   
   reg		       S;

   
   
   always @(posedge CLOCK_100MHZ) begin
     if (reset) begin
	show = 0;	
	addr = 0;
	rw = 0;
	S = 0;
     end if (next) begin
	show = 1;
	addr = addr - 1;
     end else if (S == 0) begin
	if (rx_dv) begin
	   
	   
	   rw = 1; // The mem will be written to on next clock trailing edge
	   S = 1;
	end
     end else if (S == 1) begin
	rw = 0;
	addr = addr+1;
	S = 0;
     end else begin
	
     end
   end


endmodule
   
