module misprediction_unit(
    input  wire [31:0]  i_ID_pc,
    input  wire [31:0]  i_EX_pc,
    input  wire         i_EX_pc_sel,
    output wire         o_mispred
);
    wire w_equal;
    equal_32bit equal_32bit (
        .i_a(i_ID_pc),
        .i_b(i_EX_pc),
        .o_out(w_equal)
    );
    assign o_mispred = ~w_equal & i_EX_pc_sel;
endmodule