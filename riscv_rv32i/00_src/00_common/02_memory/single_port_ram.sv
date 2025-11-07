// Quartus II Verilog Template
// Single port RAM with single synchronous read/write address 

module single_port_ram 
#(parameter DATA_WIDTH=8, parameter DEPTH=512)
(
	input  wire [(DATA_WIDTH-1):0] i_wdata,
	input  wire [$clog2(DEPTH)-1:0] i_addr,
	input  wire i_clk, i_wren,
	output wire [(DATA_WIDTH-1):0] o_rdata
);

	// Declare the RAM variable
	reg [DATA_WIDTH-1:0] r_ram[DEPTH-1:0];

	// Variable to hold the registered read address
	reg [$clog2(DEPTH)-1:0] r_addr_reg;

	integer i;

	// Initialize RAM to zero
	initial begin
		for (i = 0; i < DEPTH; i = i + 1)
			r_ram[i] = {DATA_WIDTH{1'b0}};
	end
	
	always @ (posedge i_clk) begin
		if (i_wren)
			r_ram[i_addr] <= i_wdata;

		r_addr_reg <= i_addr;
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign o_rdata = r_ram[r_addr_reg];
endmodule
