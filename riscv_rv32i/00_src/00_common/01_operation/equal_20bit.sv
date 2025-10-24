// equal_20bit
// Compares two 20-bit inputs for equality.
// Output is 1 if inputs are equal, 0 otherwise.

module equal_20bit (
    input  wire [19:0] i_a,   // First 32-bit input
    input  wire [19:0] i_b,   // Second 32-bit input
    output wire        o_out    // Result: 1 if equal, 0 if not
);

    assign o_out = ~|(i_a ^ i_b);  // Bitwise XOR then NOR reduction: outputs 1 if all bits are equal

endmodule
