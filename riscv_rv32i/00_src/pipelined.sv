module pipelined(
	input  wire 		i_clk,
	input  wire 		i_reset,
	input  wire	[31:0]	i_io_sw,
	output wire	[31:0]	o_io_lcd,
	output wire	[31:0] 	o_io_ledg,
	output wire	[31:0] 	o_io_ledr,
	output wire	[6:0]  	o_io_hex0,
	output wire	[6:0]  	o_io_hex1,
	output wire	[6:0]  	o_io_hex2,
	output wire	[6:0]  	o_io_hex3,
	output wire	[6:0]  	o_io_hex4,
	output wire	[6:0]  	o_io_hex5,
	output wire	[6:0]  	o_io_hex6,
	output wire	[6:0]  	o_io_hex7,
	output wire [31:0] 	o_pc_debug,
	output wire 		o_insn_vld
);
	wire [31:0] w_pc, w_pc_4, w_pc_new;
	wire [31:0] w_inst;
	// Reg file
	wire [31:0] w_rs1_data, w_rs2_data, w_rd_data;
	wire [31:0] w_imm;
	// ALU
	wire [31:0] w_op_a;
	wire [31:0] w_op_b;
	wire [31:0] w_alu_data;
	//LSU
	wire [31:0] w_ld_data;
	//Control logic
	wire 		w_rd_wren;
	wire [4:0]	w_imm_sel;
	wire 		w_br_un;
	wire 		w_br_lt;
	wire		w_br_eq;
	wire		w_opa_sel;
	wire		w_opb_sel;
	wire [3:0]	w_alu_op;
	wire 		w_pc_sel;
	wire [2:0]	w_type_access;
	wire		w_mem_rw;
	wire [1:0]	w_wb_sel;

	pc pc(
		.i_clk(i_clk),
		.i_inst(w_inst),
		.i_reset(i_reset), 
		.i_pc(w_pc_new),
		.o_pc(w_pc)
	);
	assign o_pc_debug = w_pc;
	
	full_adder_32bit add(
		.i_a(32'b100),
		.i_b(w_pc),
		.i_carry(1'b0),
		.o_sum(w_pc_4),
		.o_carry()
	);

	inst_mem #(.N(2048)) inst_mem(
		.i_addr_inst(w_pc), 
		.o_inst(w_inst)
	);
	
	regfile regfile(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_rd_addr(w_inst[11:7]),
		.i_rs1_addr(w_inst[19:15]),
		.i_rs2_addr(w_inst[24:20]),
		.i_rd_data(w_rd_data),
		.i_rd_wren(w_rd_wren),
		.o_rs1_data(w_rs1_data),
		.o_rs2_data(w_rs2_data)
	);
	
	imm_gen imm_gen(
		.i_inst(w_inst),
		.i_imm_sel(w_imm_sel),
		.o_imm(w_imm)
	);

	brc brc(
		.i_rs1_data(w_rs1_data),
		.i_rs2_data(w_rs2_data),
		.i_br_un(w_br_un),
		.o_br_less(w_br_lt),
		.o_br_equal(w_br_eq)
	);

	mux_2to1_32bit mux_a_sel(
		.i_in0(w_rs1_data),
		.i_in1(w_pc),
		.i_sel(w_opa_sel),
		.o_out(w_op_a)
	);

	mux_2to1_32bit mux_b_sel (
		.i_in0(w_rs2_data),
		.i_in1(w_imm),
		.i_sel(w_opb_sel),
		.o_out(w_op_b)
	);

	alu alu (
		.i_op_a(w_op_a),
		.i_op_b(w_op_b),
		.i_alu_op(w_alu_op),
		.o_alu_data(w_alu_data)
	);
	
	mux_2to1_32bit mux_pc_sel (
		.i_in0(w_pc_4),
		.i_in1(w_alu_data),
		.i_sel(w_pc_sel),
		.o_out(w_pc_new)
	);
	
	lsu lsu(
		.i_clk(i_clk),
		.i_reset(i_reset),
		.i_type_access(w_type_access),
		.i_lsu_addr(w_alu_data),
		.i_st_data(w_rs2_data),
		.i_lsu_wren(w_mem_rw),
		.o_ld_data(w_ld_data),
		.i_io_sw(i_io_sw),
		.o_io_lcd(o_io_lcd),
		.o_io_ledg(o_io_ledg),
		.o_io_ledr(o_io_ledr),
		.o_io_hex0(o_io_hex0),
		.o_io_hex1(o_io_hex1),
		.o_io_hex2(o_io_hex2),
		.o_io_hex3(o_io_hex3),
		.o_io_hex4(o_io_hex4),
		.o_io_hex5(o_io_hex5),
		.o_io_hex6(o_io_hex6),
		.o_io_hex7(o_io_hex7)
	);
	
	mux_4to1_32bit mux_wb_sel (
		.i_in0(w_ld_data),
		.i_in1(w_alu_data),
		.i_in2(w_pc_4),
		.i_in3(32'b0),
		.i_sel(w_wb_sel),
		.o_out(w_rd_data)
	);

	control_logic control_logic(
		.i_inst(w_inst),
		.i_br_lt(w_br_lt),
		.i_br_eq(w_br_eq),
		.o_br_un(w_br_un),
		.o_pc_sel(w_pc_sel),
		.o_imm_sel(w_imm_sel),
		.o_rd_wren(w_rd_wren),
		.o_insn_vld(o_insn_vld),
		.o_opa_sel(w_opa_sel),
		.o_opb_sel(w_opb_sel),
		.o_alu_op(w_alu_op),
		.o_type_access(w_type_access),
		.o_mem_rw(w_mem_rw),
		.o_wb_sel(w_wb_sel)
	);

endmodule
