// Instruction Memory Module
// - Parameterizable size
// - Word-aligned instruction fetch
// - Preloaded from HEX file

module inst_mem #(
	parameter N = 2048  // Number of 32-bit words (default: 2048)
)(
	input  wire [31:0] i_addr_inst,   // Input address (word-aligned)
	output wire [31:0] o_inst         // Output instruction
);

	// Instruction memory array (32-bit words)
	reg [31:0] r_imem [0:N-1] = '{default: 32'b0};

	// Load instructions from memory file during simulation
	initial begin
		//$readmemh("D:/Application/altera/13.0sp1/Project/Pipeline_RISC_V/pipelined_branch_prediction/02_test/00_self_test/imem.hex", r_imem);
		$readmemh("D:/Application/altera/13.0sp1/Project/Pipeline_RISC_V/pipelined_branch_prediction/02_test/isa_4b.hex", r_imem);
		//$readmemh("D:/Application/altera/13.0sp1/Project/Pipeline_RISC_V/pipelined_branch_prediction/02_test/stop_watch_ver2.hex", r_imem);
		//$readmemh("D:/Application/altera/13.0sp1/Project/Pipeline_RISC_V/pipelined_branch_prediction/02_test/stop_watch.hex", r_imem);
		//$readmemh("D:/Application/altera/13.0sp1/Project/Pipeline_RISC_V/pipelined_branch_prediction/02_test/lcd_control.hex", r_imem);
	end

	// Word-aligned access (ignores lowest 2 bits of address)
	assign o_inst = r_imem[i_addr_inst[31:2]];

endmodule
