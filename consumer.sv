`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2018 12:44:53 PM
// Design Name: 
// Module Name: consumer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module consumer( input logic clk, rst,
                 vr_i.cs_port csp,
                 output logic [7:0] data_r
               );
               
  logic        ld_en;
  
  always_ff @(posedge clk)
    if (rst) data_r <= 0;
    else if (ld_en) data_r <= csp.data;
   
               
  enum logic [2:0] { CW, C1, C2, C3 } state, next;
  
  always_ff @(posedge clk)
    if (rst) state <= CW;
    else state <= next;
  
  always_comb
    begin
      // default values
      csp.rdy = 0;
      ld_en = 0;
      next = C1;
      case (state)
        CW: begin
               csp.rdy = 1; //#1; // just for checking
              if (csp.valid)
                begin
                  ld_en = 1;
                  next = C1;
                end
              else next = CW;
              $display("consumer rdy=%d valid=%d next=%s", csp.rdy, csp.valid, next.name());
            end
        C1: next = C2;
        C2: next = C3;
        C3: next = CW;
      endcase
    end  
endmodule
