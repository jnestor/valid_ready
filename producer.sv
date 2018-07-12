`include "vr_i.sv"

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
  
  always_comb
    begin
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