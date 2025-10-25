// Mux 2 input 1 bit
// 1-bit 2-to-1 multiplexer: selects between i_in0 and i_in1 based on i_sel

module mux_2to1_1bit (
	input  wire i_in0,   // Input 0
	input  wire i_in1,   // Input 1
	input  wire i_sel,   // Select signal: 0 -> i_in0, 1 -> i_in1
	output wire o_out    // Output

);
	assign o_out = 	(~i_sel & i_in0) | // 0 
					( i_sel & i_in1);  // 1
endmodule
