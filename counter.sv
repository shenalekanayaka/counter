module counter #(parameter N = 10, W = 3)
(
  input logic clk,
  input logic rst,
  input  logic [W-1:0] in,
  output logic [6:0] ten_out,
  output logic [6:0] one_out
);
  
  logic [W-1:0] sum;
  logic [N-1:0] counter_reg;
  logic cnt_done;
  logic [3:0] tens, ones;
  
  
  function automatic logic [$clog2(N)+1:0] count();
    input logic clk, rst, incr;
    logic [$clog2(N)+1:0] cnt;
    begin
      if (rst) cnt <= 0;
      else if (incr) cnt <= cnt + 1'b1;
    end
    return cnt;
  endfunction

  
  function automatic logic [6:0] led();
    input logic [3:0] dgt;
    case (dgt):
      4'h0: return 7'b1111110;
      4'h1: return 7'b0110000;
      4'h2: return 7'b1101101;
      4'h3: return 7'b1111001;
      4'h4: return 7'b0110011;
      4'h5: return 7'b1011011;
      4'h6: return 7'b1011111;
      4'h7: return 7'b1110000;
      4'h8: return 7'b1111111;
      4'h9: return 7'b1111011;
    endcase
  endfunction
      
              
  always_ff @(posedge clk) begin
    
    if (rst) begin
      sum <= 0;
      cnt_done <= 0;
    end
    else begin
      counter_reg <= count(clk,rst,cnt_done);
      if (counter_reg == N-1) cnt_done <= 1;
      if (cnt_done) begin
        sum <= sum + in[counter_reg];
        tens = sum / 10;
        ones = sum % 10;
	end
    end
  end
  
  assign ten_out = led(tens);
  assign one_out = led(ones);


endmodule
