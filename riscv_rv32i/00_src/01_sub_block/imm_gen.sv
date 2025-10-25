module imm_gen(
	input  wire [31:0] i_inst,
	input  wire [4:0]  i_imm_sel,
	output wire [31:0] o_imm
);
	wire [31:0] w_mux1_out, w_mux2_out, w_mux3_out, w_mux4_out;
	wire [31:0] w_imm_i_type;
	wire [31:0] w_imm_s_type;
	wire [31:0] w_imm_b_type;
	wire [31:0] w_imm_uj_type;
	wire [31:0] w_imm_u_type;
	wire w_u_type_sel, w_uj_type_sel, w_b_type_sel, w_s_type_sel, w_i_type_sel;
	
	assign {w_u_type_sel, w_uj_type_sel, w_b_type_sel, w_s_type_sel, w_i_type_sel} = i_imm_sel;
	
	assign w_imm_i_type =  {{20{i_inst[31]}}, i_inst[31:20]};
	assign w_imm_s_type =  {{20{i_inst[31]}}, i_inst[31:25], i_inst[11:7]};
	assign w_imm_b_type =  {{19{i_inst[31]}}, i_inst[31], i_inst[7], i_inst[30:25], i_inst[11:8], 1'b0};
	assign w_imm_uj_type = {{11{i_inst[31]}}, i_inst[31], i_inst[19:12], i_inst[20], i_inst[30:21], 1'b0};
	assign w_imm_u_type  = {i_inst[31:12], 12'b0};
			
	mux_2to1_32bit mux1(
		.i_in0(32'b0), 
		.i_in1(w_imm_i_type),
		.i_sel(w_i_type_sel),
		.o_out(w_mux1_out)
	);
	
	mux_2to1_32bit mux2(
		.i_in0(w_mux1_out), 
		.i_in1(w_imm_s_type),
		.i_sel(w_s_type_sel),
		.o_out(w_mux2_out)
	);
	mux_2to1_32bit mux3(
		.i_in0(w_mux2_out), 
		.i_in1(w_imm_b_type),
		.i_sel(w_b_type_sel),
		.o_out(w_mux3_out)
	);
	
	mux_2to1_32bit mux4(
		.i_in0(w_mux3_out), 
		.i_in1(w_imm_uj_type),
		.i_sel(w_uj_type_sel),
		.o_out(w_mux4_out)
	);
	
	mux_2to1_32bit mux5(
		.i_in0(w_mux4_out), 
		.i_in1(w_imm_u_type),
		.i_sel(w_u_type_sel),
		.o_out(o_imm)
	);

endmodule
