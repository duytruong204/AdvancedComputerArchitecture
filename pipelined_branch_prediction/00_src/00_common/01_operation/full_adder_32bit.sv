// Full adder 32 bits
// Sums two 32-bit numbers with carry-in and outputs sum and carry-out.
module full_adder_32bit (
	input  wire [31:0] 	i_a, 		// Input operand A (32 bits)
	input  wire [31:0] 	i_b, 		// Input operand B (32 bits)
	input  wire 		i_carry,	// Initial carry-in
	output wire [31:0] 	o_sum,		// Sum output (32 bits)
	output wire 		o_carry		// Final carry-out
);
	// Internal wire to hold carry bits between stages (bit 0 to 30)
	wire [30:0] w_carry_chain;

	genvar i;
	generate
		for(i = 0; i < 32; i = i + 1) begin: serial_adder
			if(i == 0) begin
				// First bit: use external carry-in
				full_adder_1bit adder (
					.i_a(i_a[i]), 
					.i_b(i_b[i]), 
					.i_carry(i_carry), 
					.o_sum(o_sum[i]), 
					.o_carry(w_carry_chain[i])
				);
			end else 
			if(i == 31) begin
				// Last bit: pass final carry-out to output
				full_adder_1bit adder (
					.i_a(i_a[i]), 
					.i_b(i_b[i]), 
					.i_carry(w_carry_chain[i-1]), 
					.o_sum(o_sum[i]), 
					.o_carry(o_carry)
				);
			end else begin
				// Intermediate bits: chain carry signals
				full_adder_1bit adder (
					.i_a(i_a[i]), 
					.i_b(i_b[i]), 
					.i_carry(w_carry_chain[i-1]), 
					.o_sum(o_sum[i]), 
					.o_carry(w_carry_chain[i])
				);
			end
		end
	endgenerate
endmodule