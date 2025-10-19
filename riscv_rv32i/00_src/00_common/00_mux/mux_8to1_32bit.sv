// 32-bit 8-to-1 multiplexer
// Selects one of eight 32-bit inputs based on a 32-bit select signal (i_sel).
// Output is the selected 32-bit input.

module mux_8to1_32bit (
    input  wire [31:0] i_in0,  // 32-bit input 0
    input  wire [31:0] i_in1,  // 32-bit input 1
    input  wire [31:0] i_in2,  // 32-bit input 2
    input  wire [31:0] i_in3,  // 32-bit input 3
    input  wire [31:0] i_in4,  // 32-bit input 4
    input  wire [31:0] i_in5,  // 32-bit input 5
    input  wire [31:0] i_in6,  // 32-bit input 6
    input  wire [31:0] i_in7,  // 32-bit input 7
    input  wire [2:0]  i_sel,  // 3-bit select signal
    output wire [31:0] o_out   // 32-bit output
);

    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : gen_mux_8to1_1bit
            mux_8to1_1bit u_mux (
                .i_in0(i_in0[i]),
                .i_in1(i_in1[i]),
                .i_in2(i_in2[i]),
                .i_in3(i_in3[i]),
                .i_in4(i_in4[i]),
                .i_in5(i_in5[i]),
                .i_in6(i_in6[i]),
                .i_in7(i_in7[i]),
                .i_sel(i_sel),
                .o_out(o_out[i])
            );
        end
    endgenerate

endmodule
