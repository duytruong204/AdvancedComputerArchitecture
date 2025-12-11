//===========================================================
// N-bit 2-to-1 Multiplexer
// Selects between two N-bit inputs based on select signal
//===========================================================
module mux_2to1_nbit #(
    parameter N = 3 // Default width = 3 bits
)(
    input  wire [N-1:0] i_in0, // Input 0 (N bits)
    input  wire [N-1:0] i_in1, // Input 1 (N bits)
    input  wire          i_sel, // Select line
    output wire [N-1:0] o_out   // Output (N bits)
);
    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : mux_array
            mux_2to1_1bit mux (
                .i_in0(i_in0[i]),
                .i_in1(i_in1[i]),
                .i_sel(i_sel),
                .o_out(o_out[i])
            );
        end
    endgenerate
endmodule
