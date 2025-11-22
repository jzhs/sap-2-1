// To test uart: start Putty with COM4 (say) and baud rate 9600, stop bits = 1,
// parity = none, flow control = none

// Then anything typed should have ascii displayed in 7-seg digits.
// Press center button to have a 'C' (ascii 0x43) sent to host.
// Will also observe dim leds near cable connector blink during these operations.  


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


   debouncer BTNC_DEB
   (
    .clock(CLOCK_100MHZ),
    .clken(clock_1khz_rise),
    .in(btnC),
    .out_rise(tx_dv) 
   );

   debouncer BTNL_DEB
   (
    .clock(CLOCK_100MHZ),
    .clken(clock_1khz_rise),
    .in(btnL),
    .out(reset) // reset is a debounced btnL 
   );
   

   
   // 100_000_000 / 115200  =   868
   // 100_000_000 / 9600    = 10416

   wire [7:0]	       rx_byte;
   wire		       rx_dv;
   wire [7:0]	       tx_byte;
   wire		       tx_dv;
   wire		       tx_active;
   wire		       tx_done;
   
   
   UART_RX #(.CLKS_PER_BIT(10416))
   usbuartrx(
     .i_Rst_L(~reset),
     .i_Clock(CLOCK_100MHZ),
     .i_RX_Serial(RsRx),  // The Basys3 USB-UART rx line
     .o_RX_DV(rx_dv),
     .o_RX_Byte(rx_byte)
    );

   assign tx_byte = 8'h43;  // C

   
   
   UART_TX #(.CLKS_PER_BIT(10416))
   usbuarttx(
     .i_Rst_L(~reset),
     .i_Clock(CLOCK_100MHZ),
     .i_TX_DV(tx_dv),
     .i_TX_Byte(tx_byte), 
     .o_TX_Active(tx_active),
     .o_TX_Serial(RsTx),
     .o_TX_Done(tx_done)
   );
 

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
