// SLT(Set Less Than)
// Performs signed comparison: (i_a < i_b) ? 1 : 0
module slt_32bit (
	input wire [31:0] i_a, 	// Input operand A (32 bits)
	input wire [31:0] i_b, 	// Input operand B (32 bits)
	output wire 	  o_out	// Result: 1 if A < B (signed), else 0
);
	wire [31:0] 	w_sub_out; 	// Result of A - B
	wire 		w_sign_compare;	// 1 if signs of A and B differ

	// Subtract: A - B = A + (~B + 1)
	full_adder_32bit sub (
		.i_a(i_a),
		.i_b(~i_b),
		.i_carry(1'b1),
		.o_sum(w_sub_out),
		.o_carry()
	);

	// Check if signs of A and B are different
    assign w_sign_compare = i_a[31] ^ i_b[31];

	// If signs differ, result depends on sign of A
	// If signs are the same, use sign of (A - B)
	assign o_out = (w_sign_compare &  i_a[31]) | (~w_sign_compare & w_sub_out[31]);
	
endmodule
