// Byte-addressable memory module (32-bit word interface)
// Supports byte-enable write (via i_bmask), synchronous write, asynchronous read
module memory #(
	parameter DEPTH = 2048 // Number of memory bytes
)(
	input  wire                     i_clk,        // Clock
	input  wire                     i_reset,      // Active-low synchronous reset
	input  wire [$clog2(DEPTH)-1:0]		i_addr,       // Byte address (for both read/write)
	input  wire [3:0]               i_bmask,      // Byte mask (1 = enable write)
	input  wire [31:0]              i_wdata,      // Write data
	input  wire                     i_wren,       // Write enable
	output wire [31:0]             	o_rdata       // Read data (combinational)
);

	// Internal byte-addressable memory
	reg [7:0] r_mem [0:DEPTH-1];

	integer i;
	
	// Write logic: synchronous on positive clock edge
	always @(posedge i_clk or negedge i_reset) begin
		if (!i_reset) begin
			for (i = 0; i < DEPTH; i = i + 1) begin
				r_mem[i] <= 8'b0;
			end
		end else if (i_wren) begin
			if (i_bmask[0]) r_mem[i_addr + 0] <= i_wdata[7:0];
            if (i_bmask[1]) r_mem[i_addr + 1] <= i_wdata[15:8];
           	if (i_bmask[2]) r_mem[i_addr + 2] <= i_wdata[23:16];
            if (i_bmask[3]) r_mem[i_addr + 3] <= i_wdata[31:24];
		end
	end

	// Combinational read logic
	assign o_rdata[7:0]   = r_mem[i_addr + 0];
	assign o_rdata[15:8]  = r_mem[i_addr + 1];
    assign o_rdata[23:16] = r_mem[i_addr + 2];
    assign o_rdata[31:24] = r_mem[i_addr + 3];

endmodule