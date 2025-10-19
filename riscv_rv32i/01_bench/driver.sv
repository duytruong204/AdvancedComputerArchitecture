// Author: Hai Cao
// Copyright 2024

module driver (
  input  logic        i_clk   ,
  input  logic        i_rst_n ,
  output logic [31:0] i_io_sw ,
  output logic [31:0] i_io_btn
);

logic [63:0] counter;

always @(posedge i_clk) begin
  if (!i_rst_n)     counter <= 64'd0;
  else              counter <= counter + 1;
end

always_comb begin
  if (counter > 2)  i_io_sw  = 32'hA5A5_A5A5;
  else              i_io_sw  = 32'h0000_0000;
end
always_comb begin
  if (counter > 2)  i_io_btn = 32'hB5B5_B5B5;
  else              i_io_btn = 32'h0000_0000;
end


endmodule : driver
