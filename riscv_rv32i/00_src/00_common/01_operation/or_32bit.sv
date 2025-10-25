// OR module
// Performs bitwise OR operation between two 32-bit inputs

module or_32bit(
    input wire  [31:0] i_a,       // First 32-bit input operand
    input wire  [31:0] i_b,       // Second 32-bit input operand
    output wire [31:0] o_out      // 32-bit output result (a OR b)
);

    assign o_out = i_a | i_b;         // Bitwise OR operation

endmodule
