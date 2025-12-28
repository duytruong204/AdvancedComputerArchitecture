`timescale 1ns/1ps
`include "D:/Application/altera/13.0sp1/Project/Pipeline_RISC_V/pipelined_non_forwarding/00_src/include.sv"
`define RESET_PERIOD 2
`define CLK_PERIOD   1
`define FINISH 90

module pipelined_tb;
	reg  [31:0]  i_io_sw  ;
	wire [31:0]  o_io_ledr;
	wire [31:0]  o_io_ledg;
	wire [31:0]  o_io_lcd ;
	wire [ 6:0]  o_io_hex0;
	wire [ 6:0]  o_io_hex1;
	wire [ 6:0]  o_io_hex2;
	wire [ 6:0]  o_io_hex3;
	wire [ 6:0]  o_io_hex4;
	wire [ 6:0]  o_io_hex5;
	wire [ 6:0]  o_io_hex6;
	wire [ 6:0]  o_io_hex7;
	wire [31:0] o_pc_debug;
	wire 		o_insn_vld;
	wire 		o_ctrl    ;
	wire 		o_mispred ;
	reg	i_clk;
	reg i_reset;

	// Hex display decoder
	function string display_hex(input [6:0] hex);
		begin
			case (~hex)
				7'b0111111: display_hex = "0";
				7'b0000110: display_hex = "1";
				7'b1011011: display_hex = "2";
				7'b1001111: display_hex = "3";
				7'b1100110: display_hex = "4";
				7'b1101101: display_hex = "5";
				7'b1111101: display_hex = "6";
				7'b0000111: display_hex = "7";
				7'b1111111: display_hex = "8";
				7'b1101111: display_hex = "9";
				7'b1110111: display_hex = "A";
				7'b1111100: display_hex = "b";
				7'b0111001: display_hex = "C";
				7'b1011110: display_hex = "d";
				7'b1111001: display_hex = "E";
				7'b1110001: display_hex = "F";
				default:    display_hex = "?";
			endcase
		end
	endfunction

	pipelined pipelined (
		.i_clk     (i_clk       ),
		.i_reset   (i_reset     ),
		// Input peripherals
		.i_io_sw   (i_io_sw    ),
		// Output peripherals
		.o_io_lcd  (o_io_lcd   ),
		.o_io_ledr (o_io_ledr  ),
		.o_io_ledg (o_io_ledg  ),
		.o_io_hex0 (o_io_hex0  ),
		.o_io_hex1 (o_io_hex1  ),
		.o_io_hex2 (o_io_hex2  ),
		.o_io_hex3 (o_io_hex3  ),
		.o_io_hex4 (o_io_hex4  ),
		.o_io_hex5 (o_io_hex5  ),
		.o_io_hex6 (o_io_hex6  ),
		.o_io_hex7 (o_io_hex7  ),
		// Debug
		// .o_ctrl    (o_ctrl     ),
		// .o_mispred (o_mispred  ),
		.o_pc_debug(o_pc_debug ),
		.o_insn_vld(o_insn_vld )
	);
	initial begin
		i_io_sw = 32'b0;
		i_clk = 0;
		i_reset = 1;
	end
	// Clock generation
	always #`CLK_PERIOD i_clk = ~i_clk;

	// Reset logic
	initial begin
		i_clk = 0;
		i_reset = 0;
		#`RESET_PERIOD;
		i_reset = 1;
		#`FINISH;
		$display("=== Simulation Finished ===");
		$finish;
	end
	integer i, j;
	// always @ (o_io_lcd) begin
	// 	$display("%8h", o_io_lcd);
	// end
	// Show pc and instruction
	always @ (posedge i_clk) begin
	//always @ (o_pc_debug) begin
		// Show pc and instruction
		$display("Inst = IF: %8h | ID: %8h | EX: %8h | MEM: %8h | WB: %8h",
			pipelined.IF_ID_reg.i_inst,
			pipelined.IF_ID_reg.o_inst,
			pipelined.ID_EX_reg.o_inst,
			pipelined.EX_MEM_reg.o_inst,
			pipelined.MEM_WB_reg.o_inst
		);
		$display("rd_wren = ID: %8h | EX: %8h | MEM: %8h | WB: %8h",
			pipelined.ID_EX_reg.i_rd_wren,
			pipelined.ID_EX_reg.o_rd_wren,
			pipelined.EX_MEM_reg.o_rd_wren,
			pipelined.MEM_WB_reg.o_rd_wren
		);
		$display("ld_data = MEM: %8h | WB: %8h",
			pipelined.MEM_WB_reg.i_ld_data,
			pipelined.MEM_WB_reg.o_ld_data
		);
		$display("type_access = ID: %8h | EX: %8h | MEM: %8h",
			pipelined.ID_EX_reg.i_type_access,
			pipelined.ID_EX_reg.o_type_access,
			pipelined.EX_MEM_reg.o_type_access
		);
		$display("alu_data = EX: %8h | MEM: %8h | WB: %8h",
			pipelined.EX_MEM_reg.i_alu_data,
			pipelined.EX_MEM_reg.o_alu_data,
			pipelined.MEM_WB_reg.o_alu_data
		);
		$display("lsu = i_lsu_addr: %8h, i_type_access : %8h, o_ld_data : %8h, load.i_output_data: %8h, load.i_type_access : %8h",
			pipelined.lsu.i_lsu_addr,
			pipelined.lsu.i_type_access,
			pipelined.lsu.o_ld_data,
			pipelined.lsu.load.i_output_data,
			pipelined.lsu.load.i_type_access
		);
		$display("PC = %8h, Instruction = %8h", 
			pipelined.pc.o_pc, pipelined.inst_mem.o_inst
		);
		// // Show all registers
		for (i = 0; i < 8; i = i + 1) begin
			$display("R%0d = %8h | R%0d = %8h | R%0d = %8h | R%0d = %8h", 
			i*4+0, pipelined.regfile.d_flip_flop_32x32bit.o_registers[i*4+0],
			i*4+1, pipelined.regfile.d_flip_flop_32x32bit.o_registers[i*4+1],
			i*4+2, pipelined.regfile.d_flip_flop_32x32bit.o_registers[i*4+2],
			i*4+3, pipelined.regfile.d_flip_flop_32x32bit.o_registers[i*4+3]
			);
		end
		// Show first 32 memory locations
		for (i = 8; i >= 0; i = i - 1) begin
			$display("M%0d = %2h %2h %2h %2h | M%0d = %2h %2h %2h %2h | M%0d = %2h %2h %2h %2h | M%0d = %2h %2h %2h %2h", 
				i*4+3, 	pipelined.lsu.internal_memory.internal_memory.ram_col_3.r_ram[4*i+3], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_2.r_ram[4*i+3], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_1.r_ram[4*i+3], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_0.r_ram[4*i+3],
				i*4+2, 	pipelined.lsu.internal_memory.internal_memory.ram_col_3.r_ram[4*i+2], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_2.r_ram[4*i+2], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_1.r_ram[4*i+2], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_0.r_ram[4*i+2],
				i*4+1, 	pipelined.lsu.internal_memory.internal_memory.ram_col_3.r_ram[4*i+1], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_2.r_ram[4*i+1], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_1.r_ram[4*i+1], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_0.r_ram[4*i+1],
				i*4+0, 	pipelined.lsu.internal_memory.internal_memory.ram_col_3.r_ram[4*i+0], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_2.r_ram[4*i+0], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_1.r_ram[4*i+0], 
						pipelined.lsu.internal_memory.internal_memory.ram_col_0.r_ram[4*i+0]
			);
		end

		// Show IOs
		$display("LEDG = %8h, LEDR = %8h, LCD = %8h", 
			o_io_ledg, o_io_ledr, o_io_lcd
		);
		// Show hex displays
		$display("HEX7 = %2h, HEX6 = %2h, HEX5 = %2h, HEX4 = %2h, HEX3 = %2h, HEX2 = %2h, HEX1 = %2h, HEX0 = %2h", 
			o_io_hex7, o_io_hex6, o_io_hex5, o_io_hex4,
			o_io_hex3, o_io_hex2, o_io_hex1, o_io_hex0
		);
		// hex digits displayed
		$display("Hex Digits: %s%s%s%s%s%s%s%s",
			display_hex(o_io_hex7),
			display_hex(o_io_hex6),
			display_hex(o_io_hex5),
			display_hex(o_io_hex4),
			display_hex(o_io_hex3),
			display_hex(o_io_hex2),
			display_hex(o_io_hex1),
			display_hex(o_io_hex0)
		);
		// Finish simulation if instruction not valid
		// if(o_insn_vld == 0) begin
		// 	$display("Instruction not valid yet.");
		// 	$finish;
		// end
		$display("==============================");
	end

endmodule

