// 1-bit 4-to-1 multiplexer
// Selects one of 4 inputs based on 2-bit select signal i_sel
module mux_4to1_1bit (
	input  wire i_in0,    // Input 0
	input  wire i_in1,    // Input 1
	input  wire i_in2,    // Input 2
	input  wire i_in3,    // Input 3
	input  wire [1:0] i_sel, // 2-bit select signal
	output wire o_out     // Output
);
	assign o_out =  (~i_sel[1] & ~i_sel[0] & i_in0) | // 00
               		(~i_sel[1] &  i_sel[0] & i_in1) | // 01
               		( i_sel[1] & ~i_sel[0] & i_in2) | // 10
            		( i_sel[1] &  i_sel[0] & i_in3);  // 11

endmodule
