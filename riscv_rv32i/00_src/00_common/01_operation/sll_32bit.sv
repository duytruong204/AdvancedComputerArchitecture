// sll_unit
// Performs logical left shift: o_out = i_a << i_b
module sll_32bit (
   	input  wire [31:0] i_a,     // Data input
    input  wire [4:0]  i_b,     // Shift amount (0–31)
    output wire [31:0] o_out    // Shifted output
);

    wire [31:0] w_mux1_out, w_mux2_out, w_mux3_out, w_mux4_out;
	mux_2to1_32bit mux_1 (.i_in0(i_a),        .i_in1({i_a[30:0], 		 1'b0}), .i_sel(i_b[0]), .o_out(w_mux1_out)); // shift by 1
    mux_2to1_32bit mux_2 (.i_in0(w_mux1_out), .i_in1({w_mux1_out[29:0],  2'b0}), .i_sel(i_b[1]), .o_out(w_mux2_out)); // shift by 2
    mux_2to1_32bit mux_3 (.i_in0(w_mux2_out), .i_in1({w_mux2_out[27:0],  4'b0}), .i_sel(i_b[2]), .o_out(w_mux3_out)); // shift by 4
    mux_2to1_32bit mux_4 (.i_in0(w_mux3_out), .i_in1({w_mux3_out[23:0],  8'b0}), .i_sel(i_b[3]), .o_out(w_mux4_out)); // shift by 8
    mux_2to1_32bit mux_5 (.i_in0(w_mux4_out), .i_in1({w_mux4_out[15:0], 16'b0}), .i_sel(i_b[4]), .o_out(o_out));      // shift by 16

endmodule