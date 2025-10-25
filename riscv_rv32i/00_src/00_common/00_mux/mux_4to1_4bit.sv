// 4-bit 4-to-1 multiplexer
// Selects one of four 4-bit inputs based on 4-bit select signal (i_sel).
// Output is the selected 4-bit input.

module mux_4to1_4bit (
    input  wire [3:0] i_in0,    // 4-bit input 0
    input  wire [3:0] i_in1,    // 4-bit input 1
    input  wire [3:0] i_in2,    // 4-bit input 2
    input  wire [3:0] i_in3,    // 4-bit input 3
    input  wire [1:0] i_sel,    // 2-bit select signal
    output wire [3:0] o_out     // 4-bit output
);

    genvar i;
    generate
        for(i = 0; i < 4; i = i + 1) begin : gen_mux_4to1_1bit
            mux_4to1_1bit u_mux (
                .i_in0(i_in0[i]),
                .i_in1(i_in1[i]),
                .i_in2(i_in2[i]),
                .i_in3(i_in3[i]),
                .i_sel(i_sel),
                .o_out(o_out[i])
            );
        end
    endgenerate

endmodule
