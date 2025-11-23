`timescale 1ns / 1ps
`default_nettype none


module  tb_memory();

   reg sysclk;
   

   reg [9:0]	       addr;
   reg [7:0]	       data;
   wire [7:0]	       data_out;
   reg		       rw;
   

   memory ram (
     .clk(sysclk),
     .rw(rw),
     .addr(addr),
     .data_in(data),
     .data_out(data_out)
   );


   
   always #1 sysclk = ~sysclk;
 
   initial begin
      sysclk = 0;
      rw = 0;
      
      #5;
      addr = 10'h000;
      data = 8'hea;
      
      #2.2;
      rw = 1;
      #4;
      rw = 0;
      #4;
      addr = 10'h001;
      #4;
      addr = 10'h000;
      
      #10;

      $finish;
      
   end
   
endmodule
