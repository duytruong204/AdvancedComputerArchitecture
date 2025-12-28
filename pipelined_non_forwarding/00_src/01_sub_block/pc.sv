module pc (
	input  wire        i_clk,      // Clock input
	input  wire        i_reset,    // Active-low synchronous reset
	input  wire        i_stall,    // Stall signal
	input  wire [31:0] i_pc,       // Input PC value (next PC)
	output reg  [31:0] o_pc        // Output PC value (current PC)
);

	// PC update logic
	always @(posedge i_clk or negedge i_reset) begin
		if (!i_reset)
			o_pc <= 32'b0;         // Reset PC to 0
		else if (!i_stall)
			o_pc <= i_pc;          // Update PC with new value
	end

endmodule
