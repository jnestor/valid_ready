`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/11/2018 12:36:53 PM
// Design Name: 
// Module Name: vr_i
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


interface vr_i #(parameter WIDTH=16);
  logic             valid;
  logic [WIDTH-1:0] data;
  logic             rdy;
  modport pr_port(output valid, data, input rdy);  // producer port
  modport cs_port(input valid, data, output rdy);  // consumer port
endinterface: vr_i
