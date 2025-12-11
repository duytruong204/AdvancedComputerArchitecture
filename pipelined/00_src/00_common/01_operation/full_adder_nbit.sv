//===========================================================
// N-bit Full Adder
// Adds two N-bit inputs and a carry-in, produces sum and carry-out
//===========================================================
module full_adder_nbit #(
    parameter N = 32 // Default width = 32 bits
)(
    input  wire [N-1:0] i_a,      // Input operand A
    input  wire [N-1:0] i_b,      // Input operand B
    input  wire         i_carry,  // Carry-in
    output wire [N-1:0] o_sum,     // Sum output
    output wire         o_carry   // Final carry-out
);
    // Internal carry chain
    wire [N-2:0] w_carry_chain;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : gen_full_adders
            if (i == 0) begin
                // First bit uses external carry-in
                full_adder_1bit adder (
                    .i_a(i_a[i]),
                    .i_b(i_b[i]),
                    .i_carry(i_carry),
                    .o_sum(o_sum[i]),
                    .o_carry(w_carry_chain[i])
                );
            end else if (i == N-1) begin
                // Last bit outputs final carry-out
                full_adder_1bit adder (
                    .i_a(i_a[i]),
                    .i_b(i_b[i]),
                    .i_carry(w_carry_chain[i-1]),
                    .o_sum(o_sum[i]),
                    .o_carry(o_carry)
                );
            end else begin
                // Middle bits use carry chain
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
