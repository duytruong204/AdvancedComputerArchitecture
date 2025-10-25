`timescale 1ns/1ps

module singlecycle_tb(
	o_pc_debug,
	o_insn_vld
);

	reg 						i_clk;
	reg 						i_reset;
	output wire [31:0]	o_pc_debug;
	output wire 			o_insn_vld;

	// Instantiate DUT
	singlecycle singlecycle (
		.i_clk(i_clk),
		.i_reset(i_reset),
		.o_pc_debug(o_pc_debug),
		.o_insn_vld(o_insn_vld)
	);
	initial begin
		i_clk = 0;
		i_reset = 1;
	end
	// Clock generation
	always #5 i_clk = ~i_clk;

	// Reset logic
	initial begin
		i_clk = 0;
		i_reset = 0;
		#20;
		i_reset = 1;
		#360;
		$display("=== Simulation Finished ===");
		$finish;
	end
	integer i;
	// Trial for ALU and RegFile
	always @ (posedge i_clk) begin
		$display("Addr = %8h, Inst = %8h", 
			singlecycle.inst_mem.i_addr_inst, singlecycle.inst_mem.o_inst
		);
		$display("o_br_less = %8h", 
			singlecycle.brc.o_br_less
		);
		for (i = 0; i < 31; i = i + 1) begin
			$display("R%0d = %8h", 
				i, singlecycle.regfile.d_flip_flop_32x32bit.o_registers[i]
			);
		end
	end
	// Trial for ALU, Reg, and Memory,
//	always @ (posedge i_clk) begin
//		// Display register contents
//		$display("Addr = %8h, Inst = %8h", 
//			singlecycle.inst_mem.i_addr_inst, singlecycle.inst_mem.o_inst
//		);
//		$display("imm = %8h, i_imm_sel = %4b", 
//			singlecycle.imm_gen.o_imm, singlecycle.imm_gen.i_imm_sel,
//		);
//		$display("i_op_a = %8h, i_op_b = %8h, alu_data = %8h", 
//			singlecycle.alu.i_op_a, singlecycle.alu.i_op_b, singlecycle.alu.o_alu_data,
//		);
//		$display("o_mem_rw = %8h, i_mem_enable = %b, o_output_data = %8h", 
//			singlecycle.control_logic.o_mem_rw,
//			singlecycle.lsu.mux_by_enable_32bit.i_mem_enable,
//			singlecycle.lsu.mux_by_enable_32bit.o_output_data
//		);
//		for (i = 0; i < 10; i = i + 1) begin
//			$display("R%0d = %8h", i, singlecycle.regfile.d_flip_flop_32x32bit.o_registers[i]);
//		end
//		for (i = 0; i < 32; i = i + 4) begin
//			$display("M%0d = %8h|%8h|%8h|%8h", 
//			i/4, 
//			singlecycle.lsu.internal_memory.internal_memory.r_mem[i+3],  
//			singlecycle.lsu.internal_memory.internal_memory.r_mem[i+2],  
//			singlecycle.lsu.internal_memory.internal_memory.r_mem[i+1],  
//			singlecycle.lsu.internal_memory.internal_memory.r_mem[i]);
//		end
//	end
	
//	always @ (posedge i_clk) begin
//		// Display register contents
//		for (i = 0; i < 32; i = i + 4) begin
//			$display("M%0d = %8h|%8h|%8h|%8h", 
//			i/4, 
//			singlecycle.lsu.internal_memory.internal_memory.r_mem[i+3],  
//			singlecycle.lsu.internal_memory.internal_memory.r_mem[i+2],  
//			singlecycle.lsu.internal_memory.internal_memory.r_mem[i+1],  
//			singlecycle.lsu.internal_memory.internal_memory.r_mem[i]);
//		end
//	end
	
endmodule
