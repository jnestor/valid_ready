`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////
// interface declaration
////////////////////////////////////////////////////////////////////////

interface vr_i #(parameter WIDTH=16);
  logic             valid;
  logic [WIDTH-1:0] data;
  logic             rdy;
  modport pr_port(output valid, data, input rdy);  // producer port
  modport cs_port(input valid, data, output rdy);  // consumer port
endinterface: vr_i

////////////////////////////////////////////////////////////////////////
// producer FSM
////////////////////////////////////////////////////////////////////////

module producer( input clk, rst,
                 vr_i.pr_port prp
               );
               
  logic        count_en;
  logic [7:0]  count;
  
  assign prp.data = count;
  
  always_ff @(posedge clk)
    if (rst) count <= '0;
    else if (count_en) count <= count + 1;
   
               
  enum logic [2:0] { P1, P2, P3, P4, P5, PW } state, next;
  
  always_ff @(posedge clk)
    if (rst) state <= P1;
    else state <= next;
  
  always_comb   // When valid=1 and rdy=1, simulation hangs bouncing between

    begin      // this always block and the always block in ther consumer FSM
      // default values
      count_en = 0;
      prp.valid = 0;
      next = P1;
      // next state & output logic
      case (state)
        P1: begin
              count_en = 1;
              next = P2;
            end
        P2: next = P3;
        P3: next = P4;
        P4: next = P5;
        P5: next = PW;
        PW: begin
              prp.valid = 1;
              if (prp.rdy) next = P1;
              else next = PW;
              $display("producer rdy=%d valid=%d next=%s", prp.rdy, prp.valid, next.name());
            end
      endcase
    end  
endmodule: producer

////////////////////////////////////////////////////////////////////////
// Consumer FSM
////////////////////////////////////////////////////////////////////////

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
  
  always_comb  // When valid=1 and rdy=1, simulation hangs bouncing between
    begin      // this always block and the always block in ther producer FSM
      // default values
      csp.rdy = 0;
      ld_en = 0;
      next = C1;
      case (state)
        CW: begin
               csp.rdy = 1;
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

////////////////////////////////////////////////////////////////////////
// Top-level instantiates interface, producer, and consumer
////////////////////////////////////////////////////////////////////////

module top(input clk, rst);

  logic [7:0] data_c;  // data consumed by consumer

  vr_i #(.WIDTH(8)) VR();  // instantiate interface
  
  consumer C (.clk, .rst, .csp(VR.cs_port), .data_r(data_c));

  producer P (.clk, .rst, .prp(VR.pr_port));

endmodule: top

////////////////////////////////////////////////////////////////////////
//  Testbench
////////////////////////////////////////////////////////////////////////

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
