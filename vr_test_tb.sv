`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2018 02:28:03 PM
// Design Name: 
// Module Name: vr_test_tb
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


module vr_test_tb(

    );
     
    logic clk, rst;
       
    top TOP(.clk, .rst);

    
    always begin
      clk = 0; #5;
      clk = 1; #5;
    end
    
    initial begin
      rst = 1;
      @(posedge clk) #1;
      rst = 0;
      repeat (20) @(posedge clk);
      $display("All done, jack!");
      $stop;
    end
endmodule
