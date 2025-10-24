module control_logic(
	input  wire [31:0]	i_inst,
	input  wire			i_br_lt, i_br_eq,
	output wire 		o_br_un, 			//0: Signed; 1: Unsigned
	output wire 		o_pc_sel, 			// 0: +4 ; 	1: ALU
	output wire [4:0] 	o_imm_sel,			// I:00001, S:00010, B:00100, J:01000, U: 10000
	output wire			o_rd_wren,			// 0: Read; 1: Write
	output wire			o_insn_vld,			// For test
	output wire			o_opa_sel, 			//0: Reg; 1: PC
	output wire			o_opb_sel,			//0: Reg; 1: Imm
	output wire [3:0] 	o_alu_op, 			//0000: Add; 1000: Sub;....
	output wire [2:0] 	o_type_access,		//LB, LH, LBU, LHU, SW
	output wire 		o_mem_rw,			//0: Read; 1: Write
	output wire [1:0] 	o_wb_sel			//00: MemRW; 01: ALU; 10: PC
);
	wire 			w_funct7 = i_inst[30];
	wire [2:0]	w_funct3 = i_inst[14:12];
	wire [4:0] 	w_opcode = i_inst[6:2];
	wire 			w_r_type = ~w_opcode[4] &  w_opcode[3] &  w_opcode[2] & ~w_opcode[1] & ~w_opcode[0]; // 01100
	wire 			w_i_type = ~w_opcode[4] & ~w_opcode[3] &  w_opcode[2] & ~w_opcode[1] & ~w_opcode[0]; // 00100
	wire 			w_load   = ~w_opcode[4] & ~w_opcode[3] & ~w_opcode[2] & ~w_opcode[1] & ~w_opcode[0]; // 00000
	wire 			w_store  = ~w_opcode[4] &  w_opcode[3] & ~w_opcode[2] & ~w_opcode[1] & ~w_opcode[0]; // 01000
	wire 			w_branch =  w_opcode[4] &  w_opcode[3] & ~w_opcode[2] & ~w_opcode[1] & ~w_opcode[0]; // 11000
	wire 			w_jalr   =  w_opcode[4] &  w_opcode[3] & ~w_opcode[2] & ~w_opcode[1] &  w_opcode[0]; // 11001
	wire 			w_jal    =  w_opcode[4] &  w_opcode[3] & ~w_opcode[2] &  w_opcode[1] &  w_opcode[0]; // 11011
	wire 			w_lui    = ~w_opcode[4] &  w_opcode[3] &  w_opcode[2] & ~w_opcode[1] &  w_opcode[0]; // 01101
	wire 			w_auipc  = ~w_opcode[4] & ~w_opcode[3] &  w_opcode[2] & ~w_opcode[1] &  w_opcode[0]; // 00101
	
	// === Instruction Valid ===
	assign o_insn_vld = w_r_type | w_i_type | w_load | w_store | w_branch | w_jal | w_jalr | w_lui | w_auipc;
	
	//=== IMMEDIATE TYPE SELECT ===
	assign o_imm_sel = {
		w_lui | w_auipc,   			// bit 4: U-type
		w_jal,             			// bit 3: J-type
		w_branch,          			// bit 2: B-type
		w_store,           			// bit 1: S-type
		w_load | w_i_type | w_jalr 	// bit 0: I-type
	};
	// === ALU OPERAND SELECT ===
	assign o_opa_sel = w_branch | w_jal | w_auipc;	//0: Reg; 1: PC
	assign o_opb_sel = ~w_r_type; 						//0: Reg; 1: Imm
	 
	// === ALU OP ===
	wire   [3:0] w_mux1_alu_out, w_mux2_alu_out, w_mux3_alu_out;
	// Detect shift-right immediate (SRAI or SRLI)
	wire w_shift_right_i = w_i_type & (w_funct3[2] & ~w_funct3[1] &  w_funct3[0]);
	
	wire [3:0] w_alu_r_type_op    = {w_funct7, w_funct3};
	wire [3:0] w_alu_i_type_op    = {1'b0		, w_funct3};
	//if w_r_type -> w_alu_r_type_op
	//else if w_i_type -> w_alu_i_type_op
	//else if w_shift_right_i -> w_alu_r_type_op
	//else if w_lui -> 4'b1111
	//else 4'b0000
	mux_2to1_4bit mux1_alu(
		.i_in0(4'b0000),
		.i_in1(w_alu_r_type_op),
		.i_sel(w_r_type),
		.o_out(w_mux1_alu_out)
	);
	
	mux_2to1_4bit mux2_alu(
		.i_in0(w_mux1_alu_out),
		.i_in1(w_alu_i_type_op),
		.i_sel(w_i_type),
		.o_out(w_mux2_alu_out)
	);
	mux_2to1_4bit mux3_alu(
		.i_in0(w_mux2_alu_out),
		.i_in1(w_alu_r_type_op),
		.i_sel(w_shift_right_i),
		.o_out(w_mux3_alu_out)
	);
	mux_2to1_4bit mux4_alu(
		.i_in0(w_mux3_alu_out),
		.i_in1(4'b1111),
		.i_sel(w_lui),
		.o_out(o_alu_op)
	);
	
	// === Register write mode enable ===
	assign o_rd_wren = ~(w_store | w_branch);			// 0: Read; 1: Write
	 
	// === Memory write mode enable ===
	assign o_mem_rw = w_store; 							//0: Read; 1: Write
	 
	// === WB SELECT ===									
	wire   [1:0] w_mux1_wb_out, w_mux2_wb_out;
	// wire       	 w_mux1_wb_sel = w_load;
	wire       	 w_mux2_wb_sel = w_r_type | w_i_type | w_auipc | w_lui;
	wire 			 w_mux3_wb_sel = w_jal | w_jalr;
	assign w_mux1_wb_out = 2'b00;
	mux_2to1_2bit mux2_wb (
		.i_in0(w_mux1_wb_out),
		.i_in1(2'b01),
		.i_sel(w_mux2_wb_sel),
		.o_out(w_mux2_wb_out)
	 );
	 mux_2to1_2bit mux3_wb (
		.i_in0(w_mux2_wb_out),
		.i_in1(2'b10),
		.i_sel(w_mux3_wb_sel),
		.o_out(o_wb_sel) //00: MemRW; 01: ALU; 10: PC
	 );
	 
	// === pc select ===
	wire w_beq  = ~w_funct3[2] & ~w_funct3[1] & ~w_funct3[0];
	wire w_bne  = ~w_funct3[2] & ~w_funct3[1] &  w_funct3[0];
	wire w_blt  =  w_funct3[2] & ~w_funct3[1] & ~w_funct3[0];
	wire w_bge  =  w_funct3[2] & ~w_funct3[1] &  w_funct3[0];
	wire w_bltu =  w_funct3[2] &  w_funct3[1] & ~w_funct3[0];
	wire w_bgeu =  w_funct3[2] &  w_funct3[1] &  w_funct3[0];
	 
	assign o_pc_sel = w_branch & (
			(w_beq  &  i_br_eq) |
			(w_bne  & ~i_br_eq) |
			(w_blt  &  i_br_lt) |
			(w_bge  & ~i_br_lt) |
			(w_bltu &  i_br_lt) |
			(w_bgeu & ~i_br_lt)
				) | w_jal | w_jalr;
	
							
	// === BRANCH UNSIGNED (for BLTU, BGEU) ===
	assign o_br_un = w_branch & (w_bltu | w_bgeu);
	
	// === MEMORY ACCESS TYPE ===
	wire w_mux_mem_access_sel = (w_load | w_store);
	mux_2to1_3bit mux_mem_access (
		.i_in0(3'b000),
		.i_in1(w_funct3),
		.i_sel(w_mux_mem_access_sel),
		.o_out(o_type_access)
	);
	
endmodule
	