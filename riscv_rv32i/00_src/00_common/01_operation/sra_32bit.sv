// sra
// Performs arithmetic right shift: o_out = i_a >>> i_b (signed shift)
// Replicates sign bit (i_a[31]) for MSB fill during shift
module sra_32bit (
    input  wire [31:0] i_a,     // Data input (signed)
    input  wire [4:0]  i_b,     // Shift amount (0–31)
    output wire [31:0] o_out    // Shifted output (signed)
);

    wire [31:0] w_mux1_out, w_mux2_out, w_mux3_out, w_mux4_out;

    mux_2to1_32bit mux_1 (.i_in0(i_a),        .i_in1({i_a[31],        		i_a[31:1]}),        .i_sel(i_b[0]), .o_out(w_mux1_out));   // shift by 1
    mux_2to1_32bit mux_2 (.i_in0(w_mux1_out), .i_in1({{2{w_mux1_out[31]}}, 	w_mux1_out[31:2]}), .i_sel(i_b[1]), .o_out(w_mux2_out));   // shift by 2
    mux_2to1_32bit mux_3 (.i_in0(w_mux2_out), .i_in1({{4{w_mux2_out[31]}}, 	w_mux2_out[31:4]}), .i_sel(i_b[2]), .o_out(w_mux3_out));   // shift by 4
    mux_2to1_32bit mux_4 (.i_in0(w_mux3_out), .i_in1({{8{w_mux3_out[31]}}, 	w_mux3_out[31:8]}), .i_sel(i_b[3]), .o_out(w_mux4_out));   // shift by 8
    mux_2to1_32bit mux_5 (.i_in0(w_mux4_out), .i_in1({{16{w_mux4_out[31]}}, w_mux4_out[31:16]}),.i_sel(i_b[4]), .o_out(o_out));        // shift by 16

endmodule
