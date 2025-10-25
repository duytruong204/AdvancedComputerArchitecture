// SLTU (Set Less Than Unsigned)
// Outputs 1 if unsigned i_a < i_b, else 0
module sltu_32bit (
	input  wire [31:0] i_a,    // Unsigned input A
	input  wire [31:0] i_b,    // Unsigned input B
	output wire        o_out   // Output: 1 if i_a < i_b, else 0
);
	wire w_carry_out; // Carry-out from subtraction (used to detect borrow)
	
	// Subtract: A - B = A + (~B + 1)
	full_adder_32bit sub (
		.i_a(i_a),
		.i_b(~i_b),
		.i_carry(1'b1),
		.o_sum(),
		.o_carry(w_carry_out)
	);
	
	// If carry-out is 0, borrow happened => i_a < i_b (unsigned)
	assign o_out = ~w_carry_out;

endmodule