
`timescale 1ns / 1ps
`default_nettype none 

module sap2(
	    input wire sysclk,
	    input wire reset,
	    input wire clken
);

   wire [15:0]	       bus;

   wire		       sel_rom;
   wire		       sel_ram;
   
   // Control signals
   wire		       rw;
   
   wire		       pc_ld;
   wire		       pc_en;
   wire		       pc_incr;

   wire		       mar_ld;
   wire [15:0]	       mar_value;
   

   
   counter #(.size(16))
   pc (
       .sysclk(sysclk),
       .reset(reset),
       .clken(clken),
       .load(pc_ld),
       .wr_en(pc_en),
       .bus(bus)
   );


   register #(.size(16))
   mar(
       .sysclk(sysclk),
       .reset(reset),
       .clken(clken),
       .load(mar_ld),
       .data_in(bus),
       .value(mar_value)
   );

   assign sel_rom = (mar_value[15:10] == 6'b000000);
   assign sel_ram = (mar_value[15:10] == 6'b000001);

   wire [7:0]	       data_out;
   
   memory rom (
     .clk(sysclk),
     .sel(sel_rom),
     .rw(rw),
     .addr(mar_value[9:0]),
     .data_in(),          // from 8-bit MDR
     .data_out(data_out)  // to MDR
   );

   
   memory ram (
     .clk(sysclk),
     .sel(sel_ram),
     .rw(rw),
     .addr(mar_value[9:0]),
     .data_in(),          // from 8-bit MDR
     .data_out(data_out)  // to MDR
   );

   tristate_register
   mdr(
     
       );
   


endmodule
