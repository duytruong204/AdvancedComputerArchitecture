// Full adder 1 bit
// Sums two 1-bit numbers with carry-in and outputs sum and carry-out.
module full_adder_1bit (
	input  wire i_a, 	// Input bit A
	input  wire i_b, 	// Input bit B
	input  wire i_carry,	// Carry-in
	output wire o_sum,	// Sum output
	output wire o_carry	// Carry-out
);
	assign o_sum 	= i_a ^ i_b ^ i_carry;

	assign o_carry 	= (i_a & i_b) | (i_b & i_carry) | (i_a & i_carry);

endmodule