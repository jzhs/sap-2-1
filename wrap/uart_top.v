
module uart_top(
    input wire	       CLOCK_100MHZ, 
    input wire [15:0]  SW, 
    output wire [15:0] LED,
    input wire	       btnC, // attach to counter
    input wire	       btnL, // Reset
    output wire [6:0]  SEG, 
    output wire [3:0]  AN,
    input wire	       RsRx,
    output wire	       RsTx
);
   


   wire		       reset;
   wire		       clock_1khz;
   wire		       clock_1khz_rise;
   wire		       clock_1khz_fall;



   clocken #(.DIVISOR(100000))
   clockenable1
   (
    .sysclk(CLOCK_100MHZ),
    .slow_clock(clock_1khz),
    .slow_rise(clock_1khz_rise),
    .slow_fall(clock_1khz_fall)
   );


   // 100_000_000 / 115200  =  868

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

   
//   UART_TX #(.CLKS_PER_BIT(10416))
//   usbuarttx(
//     .i_Rst_L(reset),
//     .i_Clock(CLOCK_100MHZ),
//     .i_TX_DV,
//     .i_TX_Byte, 
//   output reg  o_TX_Active,
//   output reg  o_TX_Serial,
//   output reg  o_TX_Done
//   );
 

   hexout_4_digits hex_display
   (
    .clk(CLOCK_100MHZ),
    .clken(clock_1khz_rise),
    .reset(reset),
    .word({8'b0, rx_byte}),
    .seg(SEG),
    .an(AN)
   );

   
endmodule
