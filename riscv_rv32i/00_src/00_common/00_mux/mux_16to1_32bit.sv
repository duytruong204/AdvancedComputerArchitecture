// 16-to-1 Multiplexer (32-bit inputs)
// Selects one of 16 32-bit inputs based on 4-bit select signal `i_sel`
// Outputs the selected 32-bit input on `o_out`
module mux_16to1_32bit (
	input  wire [31:0] i_in0,  i_in1,  i_in2,  i_in3,
	input  wire [31:0] i_in4,  i_in5,  i_in6,  i_in7,
	input  wire [31:0] i_in8,  i_in9,  i_in10, i_in11,
	input  wire [31:0] i_in12, i_in13, i_in14, i_in15,
	input  wire [3:0]  i_sel,           // 4-bit select signal
	output wire [31:0] o_out            // Selected output
);

	genvar i;
	generate
		for (i = 0; i < 32; i = i + 1) begin: mux_array
			mux_16to1_1bit mux (
				.i_in0(i_in0[i]),  .i_in1(i_in1[i]),  .i_in2(i_in2[i]),  .i_in3(i_in3[i]),
				.i_in4(i_in4[i]),  .i_in5(i_in5[i]),  .i_in6(i_in6[i]),  .i_in7(i_in7[i]),
				.i_in8(i_in8[i]),  .i_in9(i_in9[i]),  .i_in10(i_in10[i]), .i_in11(i_in11[i]),
				.i_in12(i_in12[i]), .i_in13(i_in13[i]), .i_in14(i_in14[i]), .i_in15(i_in15[i]),
				.i_sel(i_sel),
				.o_out(o_out[i])
			);
		end
	endgenerate

endmodule

