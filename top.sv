module top(input clk, rst);

  logic [7:0] data_c;  // data consumed by consumer

  vr_i #(.WIDTH(8)) VR();  // instantiate interface
  
  consumer C (.clk, .rst, .csp(VR.cs_port), .data_r(data_c));

  producer P (.clk, .rst, .prp(VR.pr_port));

endmodule: top 