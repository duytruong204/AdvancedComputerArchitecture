// equal_nbit
// Compares two nbit for equality.
// Output is 1 if inputs are equal, 0 otherwise.

module equal_nbit #(
    parameter DATA_WIDTH = 32
) 
(
    input  wire [DATA_WIDTH-1:0] i_a,   // First n-bit input
    input  wire [DATA_WIDTH-1:0] i_b,   // Second n-bit input
    output wire        o_out    // Result: 1 if equal, 0 if not
);

    assign o_out = ~|(i_a ^ i_b);  // Bitwise XOR then NOR reduction: outputs 1 if all bits are equal

endmodule
