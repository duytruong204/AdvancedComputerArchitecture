module brc(
	input 	wire [31:0] i_rs1_data,
	input 	wire [31:0] i_rs2_data,
	input 	wire i_br_un,
	output 	wire o_br_less,
	output 	wire o_br_equal
);
	wire w_slt_result;
	wire w_sltu_result;
	wire w_equal_result;
	
	slt_32bit slt_32bit (
		.i_a(i_rs1_data), 
		.i_b(i_rs2_data) , 
		.o_out(w_slt_result)
	);
	sltu_32bit sltu_32bit (
		.i_a(i_rs1_data),
		.i_b(i_rs2_data), 
		.o_out(w_sltu_result)
	);
	
	mux_2to1_1bit mux_2to1_1bit (
		.i_in0(w_slt_result),
		.i_in1(w_sltu_result),
		.i_sel(i_br_un),
		.o_out(o_br_less)
	);
	
	equal_32bit	equal_32bit (
		.i_a(i_rs1_data),
		.i_b(i_rs2_data), 
		.o_out(o_br_equal)
	);
	
endmodule